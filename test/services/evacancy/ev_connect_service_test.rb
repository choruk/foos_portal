require 'test_helper'

module Evacancy
  class EvConnectServiceTest < ActiveSupport::TestCase
    setup do
      travel_to(Time.now)
      @token = EvConnectToken.create(access_token: 'access_token', refresh_token: 'refresh_token', expires_at: Time.now + 30)
      @station1 = EvConnectStationPort.create(qr_code: 'a1', port_status: 'AVAILABLE')
      @station2 = EvConnectStationPort.create(qr_code: 'a2', port_status: 'AVAILABLE')
    end

    def test_check_ports
      response = mock
      body = {
        portStatus: 'AVAILABLE'
      }.to_json
      response.expects(:body).returns(body).twice

      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station1.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(response)
      RestClient.expects(:get).with("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{@station2.qr_code}", { 'EVC-API-TOKEN' => @token.access_token }).returns(response)

      Evacancy::EvConnectService.check_ports

      assert_equal @station1.reload.port_status, 'AVAILABLE'
      assert_equal @station2.reload.port_status, 'AVAILABLE'
    end

    def test_check_ports__one_spot_opens
      @station1.update(port_status: 'CHARGING')
      @station2.update(port_status: 'CHARGING')

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

      SlackWebhookService.expects(:send_message).with('A spot is available!')

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

      SlackWebhookService.expects(:send_message).with('All spots have been taken!')

      @station1.update(port_status: 'AVAILABLE')

      Evacancy::EvConnectService.check_ports

      assert_equal @station1.reload.port_status, 'CHARGING'
      assert_equal @station2.reload.port_status, 'CHARGING'
    end

    def test_get_access_token
      @token.destroy!

      auth_response = mock
      auth_body = {
        accessToken: 'new_access_token',
        refresh_token: 'new_refresh_token',
        expires_at: (Time.now + 100)
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
      @token.update(expires_at: Time.now - 30)

      refresh_response = mock
      refresh_body = {
        accessToken: 'new_access_token',
        refresh_token: 'new_refresh_token',
        expires_at: (Time.now + 100)
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
      @token.update(expires_at: Time.now - 30)

      refresh_payload = { token: @token.refresh_token }.to_json
      RestClient.expects(:put).with('https://api.evconnect.com/rest/v6/auth', refresh_payload, { content_type: :json }).throws('error')

      auth_response = mock
      auth_body = {
        accessToken: 'new_access_token',
        refresh_token: 'new_refresh_token',
        expires_at: (Time.now + 100)
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
