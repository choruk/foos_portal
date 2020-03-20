module Evacancy
  class EvConnectService
    EV_CHARGERS_OF_50_CHANNEL_ID = 'CBJNVA87R'.freeze
    # Currently we only have one building so the channel ID can be hard coded
    # eventually when we have more buildings we may need a Locations model containing
    # attributes like channel_id, webhook_url, and has_many StationPorts

    AVAILABLE = 'AVAILABLE'.freeze

    class << self
      def check_ports
        token = check_access_token

        previously_open = 0
        currently_open = 0

        EvConnectStationPort.all.each do |station|
          new_status = get_status(token, station.qr_code)
          previously_open += 1 if station.port_status == AVAILABLE
          currently_open += 1 if new_status == AVAILABLE
          station.update!(port_status: new_status)
        end

        if previously_open === 0 and currently_open > 0
          channel_queue = ChannelQueue.find_by(slack_channel_id: EV_CHARGERS_OF_50_CHANNEL_ID)
          first_user = channel_queue.first_user_in_line
          next_in_line = first_user ? "<@#{first_user.slack_user_id}>" : "No one"

          message = <<~MESSAGE
            A spot is available!
            #{next_in_line} is next in line!
            Please dequeue with `/queue charging` after you plug in!
          MESSAGE

          SlackWebhookService.send_message(message)
        elsif previously_open > 0 and currently_open === 0
          message = <<~MESSAGE
            All spots have been taken!
            Please dequeue with `/queue charging` if you just plugged in!
          MESSAGE

          SlackWebhookService.send_message(message)
        end
      end

      private

      def check_access_token
        token = EvConnectToken.first

        if token.nil?
          token = get_access_token
        elsif token.expired?
          token = refresh_access_token(token)
        end

        token
      end

      def get_access_token
        payload = { email: ENV['EVCONNECT_EMAIL'], password: ENV['EVCONNECT_PASSWORD'], networkId: 'ev-connect' }.to_json
        response = RestClient.post('https://api.evconnect.com/rest/v6/auth', payload, { content_type: :json })
        body = JSON.parse(response.body)
        EvConnectToken.create!(access_token: body['accessToken'], refresh_token: body['refreshToken'], expires_at: body['expiresAt'])
      end

      def refresh_access_token(token)
        payload = { token: token.refresh_token }.to_json
        response = RestClient.put('https://api.evconnect.com/rest/v6/auth', payload, { content_type: :json })
        body = JSON.parse(response.body)
        token.destroy!
        EvConnectToken.create!(access_token: body['accessToken'], refresh_token: body['refreshToken'], expires_at: body['expiresAt'])
      rescue
        token.destroy!
        get_access_token
      end

      def get_status(token, station)
        access_token = token.access_token
        response = RestClient.get("https://api.evconnect.com/rest/v6/networks/ev-connect/stationPorts?qrCode=#{station}", { 'EVC-API-TOKEN' => access_token })
        body = JSON.parse(response.body)
        body['portStatus']
      end
    end
  end
end
