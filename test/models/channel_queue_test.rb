require 'test_helper'

class ChannelQueueTest < ActiveSupport::TestCase
  def test_validates_presence_of_slack_channel_name
    queue = ChannelQueue.new(slack_channel_id: 'U1234')
    assert_not_predicate queue, :valid?

    queue.slack_channel_name = 'ev-chargers-of-appfolio'
    assert_predicate queue, :valid?
  end

  def test_validates_presence_of_slack_channel_id
    queue = ChannelQueue.new(slack_channel_name: 'ev-chargers-of-appfolio')
    assert_not_predicate queue, :valid?

    queue.slack_channel_id = 'U1234'
    assert_predicate queue, :valid?
  end

  def test_validates_uniqueness_of_slack_channel_name
    ChannelQueue.create!(slack_channel_name: 'ev-chargers-of-appfolio', slack_channel_id: 'U1234')

    queue = ChannelQueue.new(slack_channel_name: 'ev-chargers-of-appfolio', slack_channel_id: 'X9853')
    assert_not_predicate queue, :valid?

    queue.slack_channel_name = 'different'
    assert_predicate queue, :valid?
  end

  def test_validates_uniqueness_of_slack_channel_id
    ChannelQueue.create!(slack_channel_id: 'U1234', slack_channel_name: 'ev-chargers-of-appfolio')

    queue = ChannelQueue.new(slack_channel_id: 'U1234', slack_channel_name: 'different')
    assert_not_predicate queue, :valid?

    queue.slack_channel_id = 'X9853'
    assert_predicate queue, :valid?
  end

  def test_has_many_channel_queue_memberships
    channel_queue = ChannelQueue.create!(slack_channel_name: 'ev-chargers-of-appfolio', slack_channel_id: 'U1234')

    channel_queue_membership = ChannelQueueMembership.create!(channel_queue: channel_queue, user: User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500))

    assert_equal [channel_queue_membership], channel_queue.channel_queue_memberships
  end

  def test_members_string
    channel_queue = ChannelQueue.create!(slack_channel_name: 'ev-chargers-of-appfolio', slack_channel_id: 'U1234')

    channel_queue_membership = ChannelQueueMembership.create!(channel_queue: channel_queue, user: User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500), created_at: Time.now)
    channel_queue_membership = ChannelQueueMembership.create!(channel_queue: channel_queue, user: User.create!(slack_user_id: '2', slack_user_name: 'jane', rank: 1500), created_at: 5.minutes.ago)

    assert_equal '1. jane 2. joe', channel_queue.members_string
  end

  def test_members_string__empty
    channel_queue = ChannelQueue.create!(slack_channel_name: 'ev-chargers-of-appfolio', slack_channel_id: 'U1234')

    assert_equal 'Queue is empty', channel_queue.members_string
  end
end
