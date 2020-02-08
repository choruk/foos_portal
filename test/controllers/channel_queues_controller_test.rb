require 'test_helper'

class ChannelQueuesControllerTest < ActionController::TestCase
  def test_index
    expected_response_body = { text: 'response body text' }
    ChannelQueues::ResponseRetriever.expects(:retrieve).with('list', 'C123', 'my-channel', 'U123', 'my.user').returns(expected_response_body)

    get :index, { text: 'list', token: '12345', channel_id: 'C123', channel_name: 'my-channel', user_id: 'U123', user_name: 'my.user' }
    assert_response :ok
    body = JSON.parse(response.body).symbolize_keys
    assert_equal expected_response_body, body
  end
end
