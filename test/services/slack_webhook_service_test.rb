require 'test_helper'

class SlackWebhookServiceTest < ActiveSupport::TestCase
  def test_send_message
    hooks = ENV['SLACK_WEBHOOKS'].split(', ')
    message = 'test message'

    RestClient.expects(:post).with(hooks[0], { text: message }.to_json).once
    RestClient.expects(:post).with(hooks[1], { text: message }.to_json).once

    SlackWebhookService.send_message(message)
  end
end
