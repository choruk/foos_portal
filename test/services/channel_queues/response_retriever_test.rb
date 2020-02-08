require 'test_helper'

module MeetingRoom
  class ResponseRetrieverTest < ActiveSupport::TestCase
    def test_retrieve__help
      response = ChannelQueues::ResponseRetriever.retrieve('help', 'C123', 'my-channel', 'U123', 'my.user')
      assert_equal "_/queue list_\t\tshow current queue in order from first to last\n_/queue join_\t\tjoin the queue\n_/queue leave_\t\tleave the queue\n_/queue charging_\t\tleave the queue", response[:text]
      assert_equal 'ephemeral', response[:response_type]
    end

    def test_retrieve__list
      channel_queue = ChannelQueue.create!(slack_channel_name: 'my-channel', slack_channel_id: 'C123')

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      second_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: second_user, channel_queue: channel_queue)

      response = ChannelQueues::ResponseRetriever.retrieve('list', 'C123', 'my-channel', 'U123', 'my.user')
      assert_equal "```1. first.user\n2. second.user```", response[:text]
      assert_equal 'in_channel', response[:response_type]
    end

    def test_retrieve__join
      assert_difference 'ChannelQueueMembership.count' do
        response = ChannelQueues::ResponseRetriever.retrieve('join', 'C123', 'my-channel', 'U123', 'my.user')
        assert_equal 'my.user joined queue for my-channel.', response[:text]
        assert_equal 'in_channel', response[:response_type]
      end

      channel_queue = ChannelQueue.last
      assert_equal 'C123', channel_queue.slack_channel_id
      assert_equal 'my-channel', channel_queue.slack_channel_name

      user = User.last
      assert_equal 'U123', user.slack_user_id
      assert_equal 'my.user', user.slack_user_name

      channel_queue_membership = ChannelQueueMembership.last
      assert_equal user, channel_queue_membership.user
      assert_equal channel_queue, channel_queue_membership.channel_queue
    end

    def test_retrieve__join__already_a_member
      channel_queue = ChannelQueue.create!(slack_channel_name: 'my-channel', slack_channel_id: 'C123')
      user = User.create!(slack_user_name: 'my.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: user, channel_queue: channel_queue)

      assert_no_difference 'ChannelQueueMembership.count' do
        response = ChannelQueues::ResponseRetriever.retrieve('join', 'C123', 'my-channel', 'U123', 'my.user')
        assert_equal 'my.user already in queue for my-channel.', response[:text]
        assert_equal 'in_channel', response[:response_type]
      end

      channel_queue = ChannelQueue.last
      assert_equal 'C123', channel_queue.slack_channel_id
      assert_equal 'my-channel', channel_queue.slack_channel_name

      user = User.last
      assert_equal 'U123', user.slack_user_id
      assert_equal 'my.user', user.slack_user_name

      channel_queue_membership = ChannelQueueMembership.last
      assert_equal user, channel_queue_membership.user
      assert_equal channel_queue, channel_queue_membership.channel_queue
    end

    def test_retrieve__leave
      channel_queue = ChannelQueue.create!(slack_channel_name: 'my-channel', slack_channel_id: 'C123')
      user = User.create!(slack_user_name: 'my.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: user, channel_queue: channel_queue)

      assert_difference 'ChannelQueueMembership.count', -1 do
        response = ChannelQueues::ResponseRetriever.retrieve('leave', 'C123', 'my-channel', 'U123', 'my.user')
        assert_equal 'my.user has left queue for my-channel.', response[:text]
        assert_equal 'in_channel', response[:response_type]
      end
    end

    def test_retrieve__leave__does_not_exist
      assert_no_difference 'ChannelQueueMembership.count' do
        response = ChannelQueues::ResponseRetriever.retrieve('leave', 'C123', 'my-channel', 'U123', 'my.user')
        assert_equal 'my.user has left queue for my-channel.', response[:text]
        assert_equal 'in_channel', response[:response_type]
      end
    end

    def test_retrieve__charging
      channel_queue = ChannelQueue.create!(slack_channel_name: 'my-channel', slack_channel_id: 'C123')
      user = User.create!(slack_user_name: 'my.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: user, channel_queue: channel_queue)

      assert_difference 'ChannelQueueMembership.count', -1 do
        response = ChannelQueues::ResponseRetriever.retrieve('charging', 'C123', 'my-channel', 'U123', 'my.user')
        assert_equal 'my.user has left queue for my-channel.', response[:text]
        assert_equal 'in_channel', response[:response_type]
      end
    end

    def test_retrieve__charging__does_not_exist
      assert_no_difference 'ChannelQueueMembership.count' do
        response = ChannelQueues::ResponseRetriever.retrieve('charging', 'C123', 'my-channel', 'U123', 'my.user')
        assert_equal 'my.user has left queue for my-channel.', response[:text]
        assert_equal 'in_channel', response[:response_type]
      end
    end

    def test_retrieve__other
      response = ChannelQueues::ResponseRetriever.retrieve('other', 'C123', 'my-channel', 'U123', 'my.user')
      assert_equal 'Sorry, command not recognized.', response[:text]
      assert_equal 'in_channel', response[:response_type]
    end
  end
end
