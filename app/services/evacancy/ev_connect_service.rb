module Evacancy
  class EvConnectService
    class << self
      def check_ports
        token = check_access_token

        previously_open = 0
        currently_open = 0

        EvConnectStationPort.all.each do |station|
          new_status = get_status(token, station.qr_code)
          previously_open += 1 if station.port_status == 'AVAILABLE'
          currently_open += 1 if new_status == 'AVAILABLE'
          station.update!(port_status: new_status)
        end

        if previously_open === 0 and currently_open > 0
          SlackWebhookService.send_message('A spot is available!')
        elsif previously_open > 0 and currently_open === 0
          SlackWebhookService.send_message('All spots have been taken!')
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
