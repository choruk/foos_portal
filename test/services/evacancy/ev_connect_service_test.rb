require 'test_helper'

module Evacancy
  class EvConnectServiceTest < ActiveSupport::TestCase
    EV_CHARGERS_OF_50_CHANNEL_ID = 'CBJNVA87R'.freeze

    setup do
      travel_to(Time.now)
      @token = EvConnectToken.create!(access_token: 'access_token', refresh_token: 'refresh_token', expires_at: Time.now + 30)
      @station1 = EvConnectStationPort.create!(qr_code: 'a1', port_status: 'AVAILABLE')
      @station2 = EvConnectStationPort.create!(qr_code: 'a2', port_status: 'AVAILABLE')

      @channel_queue = ChannelQueue.create(slack_channel_id: EV_CHARGERS_OF_50_CHANNEL_ID, slack_channel_name: 'test')
    end

    def test_check_ports
      response = mock
      body = {
        portStatus: 'AVAILABLE'
      }.to_json
      response.expects(:body).returns(body).twice

      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station1.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(response)
      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station2.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(response)

      ChannelQueues::NextInQueue.expects(:new).never
      SlackWebhookService.expects(:send_message).never

      Evacancy::EvConnectService.check_ports

      assert_equal @station1.reload.port_status, 'AVAILABLE'
      assert_equal @station2.reload.port_status, 'AVAILABLE'
    end

    def test_check_ports__one_spot_opens__someone_in_line
      @station1.update!(port_status: 'CHARGING')
      @station2.update!(port_status: 'CHARGING')

      available_response = mock
      available_body = {
        portStatus: 'AVAILABLE'
      }.to_json
      available_response.expects(:body).returns(available_body)

      charging_response = mock
      charging_body = {
        portStatus: 'CHARGING'
      }.to_json
      charging_response.expects(:body).returns(charging_body)

      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station1.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(available_response)
      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station2.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(charging_response)

      mock_next_in_queue = mock
      ChannelQueues::NextInQueue.expects(:new).with(channel_id: EV_CHARGERS_OF_50_CHANNEL_ID).returns(mock_next_in_queue)
      mock_next_in_queue.expects(:user_id).returns('dummy user id')

      message = <<~MESSAGE
            A spot is available!
            <@dummy user id> is next in line!
            Please dequeue with `/queue charging` after you plug in!
      MESSAGE

      SlackWebhookService.expects(:send_message).with(message)

      Evacancy::EvConnectService.check_ports

      assert_equal @station1.reload.port_status, 'AVAILABLE'
      assert_equal @station2.reload.port_status, 'CHARGING'
    end

    def test_check_ports__one_spot_opens__no_one_in_line
      @station1.update!(port_status: 'CHARGING')
      @station2.update!(port_status: 'CHARGING')

      available_response = mock
      available_body = {
        portStatus: 'AVAILABLE'
      }.to_json
      available_response.expects(:body).returns(available_body)

      charging_response = mock
      charging_body = {
        portStatus: 'CHARGING'
      }.to_json
      charging_response.expects(:body).returns(charging_body)

      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station1.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(available_response)
      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station2.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(charging_response)

      message = <<~MESSAGE
            A spot is available!
            No one is next in line!
            Please dequeue with `/queue charging` after you plug in!
      MESSAGE

      SlackWebhookService.expects(:send_message).with(message)

      Evacancy::EvConnectService.check_ports

      assert_equal @station1.reload.port_status, 'AVAILABLE'
      assert_equal @station2.reload.port_status, 'CHARGING'
    end

    def test_check_ports__all_spots_close
      response = mock
      body = {
        portStatus: 'CHARGING'
      }.to_json
      response.expects(:body).returns(body).twice

      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station1.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(response)
      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station2.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(response)

      ChannelQueues::NextInQueue.expects(:new).never

      message = <<~MESSAGE
            All spots have been taken!
            Please dequeue with `/queue charging` if you just plugged in!
      MESSAGE

      SlackWebhookService.expects(:send_message).with(message)

      @station1.update!(port_status: 'AVAILABLE')

      Evacancy::EvConnectService.check_ports

      assert_equal @station1.reload.port_status, 'CHARGING'
      assert_equal @station2.reload.port_status, 'CHARGING'
    end

    def test_get_access_token
      @token.destroy!

      auth_response = mock
      auth_body = {
        accessToken: 'new_access_token',
        refreshToken: 'new_refresh_token',
        expiresAt: (Time.now + 100)
      }.to_json
      auth_response.expects(:body).returns(auth_body)
      auth_payload = { email: ENV['EVCONNECT_EMAIL'], password: ENV['EVCONNECT_PASSWORD'], networkId: 'ev-connect' }.to_json

      RestClient.expects(:post).with('https://api.evconnect.com/rest/v6/auth', auth_payload, { content_type: :json }).returns(auth_response)

      response = mock
      body = {
        portStatus: 'AVAILABLE'
      }.to_json
      response.expects(:body).returns(body).twice

      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station1.qr_code}", { 'EVC-API-TOKEN' => 'new_access_token' }).returns(response)
      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station2.qr_code}", { 'EVC-API-TOKEN' => 'new_access_token' }).returns(response)

      Evacancy::EvConnectService.check_ports
    end

    def test_refresh_access_token
      @token.update!(expires_at: Time.now - 30)

      refresh_response = mock
      refresh_body = {
        accessToken: 'new_access_token',
        refreshToken: 'new_refresh_token',
        expiresAt: (Time.now + 100)
      }.to_json
      refresh_response.expects(:body).returns(refresh_body)
      refresh_payload = { token: @token.refresh_token }.to_json

      RestClient.expects(:put).with('https://api.evconnect.com/rest/v6/auth', refresh_payload, { content_type: :json }).returns(refresh_response)

      response = mock
      body = {
        portStatus: 'AVAILABLE'
      }.to_json
      response.expects(:body).returns(body).twice

      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station1.qr_code}", { 'EVC-API-TOKEN' => 'new_access_token' }).returns(response)
      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station2.qr_code}", { 'EVC-API-TOKEN' => 'new_access_token' }).returns(response)

      Evacancy::EvConnectService.check_ports
    end

    def test_refresh_access_token__error
      @token.update!(expires_at: Time.now - 30)

      refresh_payload = { token: @token.refresh_token }.to_json
      RestClient.expects(:put).with('https://api.evconnect.com/rest/v6/auth', refresh_payload, { content_type: :json }).throws('error')

      auth_response = mock
      auth_body = {
        accessToken: 'new_access_token',
        refreshToken: 'new_refresh_token',
        expiresAt: (Time.now + 100)
      }.to_json
      auth_response.expects(:body).returns(auth_body)
      auth_payload = { email: ENV['EVCONNECT_EMAIL'], password: ENV['EVCONNECT_PASSWORD'], networkId: 'ev-connect' }.to_json

      RestClient.expects(:post).with('https://api.evconnect.com/rest/v6/auth', auth_payload, { content_type: :json }).returns(auth_response)

      response = mock
      body = {
        portStatus: 'AVAILABLE'
      }.to_json
      response.expects(:body).returns(body).twice

      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station1.qr_code}", { 'EVC-API-TOKEN' => 'new_access_token' }).returns(response)
      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station2.qr_code}", { 'EVC-API-TOKEN' => 'new_access_token' }).returns(response)

      Evacancy::EvConnectService.check_ports
    end
  end
end
