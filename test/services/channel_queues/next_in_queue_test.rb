require 'test_helper'

module MeetingRoom
  class NextInQueueTest < ActiveSupport::TestCase
    def test_user_name
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      second_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: second_user, channel_queue: channel_queue)

      assert_equal first_user.slack_user_name, ChannelQueues::NextInQueue.new(channel_id: channel_id, channel_name: channel_name).user_name
    end

    def test_user_name__created_at
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      earlier_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: earlier_user, channel_queue: channel_queue, created_at: Time.zone.now - 10.minutes)

      assert_equal earlier_user.slack_user_name, ChannelQueues::NextInQueue.new(channel_id: channel_id, channel_name: channel_name).user_name
    end

    def test_user_name__queue_empty
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      assert_nil ChannelQueues::NextInQueue.new(channel_id: channel_id, channel_name: channel_name).user_name
    end

    def test_user_name__no_queue
      assert_nil ChannelQueues::NextInQueue.new(channel_id: 'C123', channel_name: 'my-channel').user_name
    end

    def test_user_name__channel_queue
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      second_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: second_user, channel_queue: channel_queue)

      assert_equal first_user.slack_user_name, ChannelQueues::NextInQueue.new(channel_queue: channel_queue).user_name
    end

    def test_user_name__channel_queue__created_at
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      earlier_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: earlier_user, channel_queue: channel_queue, created_at: Time.zone.now - 10.minutes)

      assert_equal earlier_user.slack_user_name, ChannelQueues::NextInQueue.new(channel_queue: channel_queue).user_name
    end

    def test_user_name__channel_queue__queue_empty
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      assert_nil ChannelQueues::NextInQueue.new(channel_queue: channel_queue).user_name
    end

    def test_user_name__channel_queue__no_queue
      assert_nil ChannelQueues::NextInQueue.new(channel_queue: nil).user_name
    end

    def test_user_id
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      second_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: second_user, channel_queue: channel_queue)

      assert_equal first_user.slack_user_id, ChannelQueues::NextInQueue.new(channel_id: channel_id, channel_name: channel_name).user_id
    end

    def test_user_id__created_at
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      earlier_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: earlier_user, channel_queue: channel_queue, created_at: Time.zone.now - 10.minutes)

      assert_equal earlier_user.slack_user_id, ChannelQueues::NextInQueue.new(channel_id: channel_id, channel_name: channel_name).user_id
    end

    def test_user_id__queue_empty
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      assert_nil ChannelQueues::NextInQueue.new(channel_id: channel_id, channel_name: channel_name).user_id
    end

    def test_user_id__no_queue
      assert_nil ChannelQueues::NextInQueue.new(channel_id: 'C123', channel_name: 'my-channel').user_id
    end

    def test_user_id__channel_queue
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      second_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: second_user, channel_queue: channel_queue)

      assert_equal first_user.slack_user_id, ChannelQueues::NextInQueue.new(channel_queue: channel_queue).user_id
    end

    def test_user_id__channel_queue__created_at
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      first_user = User.create!(slack_user_name: 'first.user', slack_user_id: 'U123')
      ChannelQueueMembership.create!(user: first_user, channel_queue: channel_queue)

      earlier_user = User.create!(slack_user_name: 'second.user', slack_user_id: 'U124')
      ChannelQueueMembership.create!(user: earlier_user, channel_queue: channel_queue, created_at: Time.zone.now - 10.minutes)

      assert_equal earlier_user.slack_user_id, ChannelQueues::NextInQueue.new(channel_queue: channel_queue).user_id
    end

    def test_user_id__channel_queue__queue_empty
      channel_id = 'C123'
      channel_name = 'my-channel'

      channel_queue = ChannelQueue.create!(slack_channel_id: channel_id, slack_channel_name: channel_name)

      assert_nil ChannelQueues::NextInQueue.new(channel_queue: channel_queue).user_id
    end

    def test_user_id__channel_queue__no_queue
      assert_nil ChannelQueues::NextInQueue.new(channel_queue: nil).user_id
    end
  end
end
