class SlackWebhookService
  def self.send_message(message)
    ENV['SLACK_WEBHOOKS'].split(', ').each do |hook|
      body = { text: message }.to_json
      RestClient.post(hook, body)
    end
  end
end
