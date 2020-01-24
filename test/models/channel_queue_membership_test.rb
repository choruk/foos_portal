require 'test_helper'

class ChannelQueueMembershipTest < ActiveSupport::TestCase
  def test_validates_presence_of_channel_queue
    channel_queue_membership = ChannelQueueMembership.new(user: User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500))
    assert_not_predicate channel_queue_membership, :valid?

    channel_queue_membership.channel_queue = ChannelQueue.create!(channel: 'ev-chargers-of-appfolio')
    assert_predicate channel_queue_membership, :valid?
  end

  def test_validates_presence_of_user
    channel_queue_membership = ChannelQueueMembership.new(channel_queue: ChannelQueue.create!(channel: 'ev-chargers-of-appfolio'))
    assert_not_predicate channel_queue_membership, :valid?

    channel_queue_membership.user = User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500)
    assert_predicate channel_queue_membership, :valid?
  end

  def test_validates_uniqueness_of_user_and_channel
    channel_queue = ChannelQueue.create!(channel: 'ev-chargers-of-appfolio')
    user = User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500)

    ChannelQueueMembership.create!(channel_queue: channel_queue, user: user)

    invalid_queue_membership = ChannelQueueMembership.new(channel_queue: channel_queue, user: user)
    assert_not_predicate invalid_queue_membership, :valid?

    different_user_queue_membership = ChannelQueueMembership.new(channel_queue: channel_queue, user: User.create!(slack_user_id: '2', slack_user_name: 'different', rank: 1500))
    assert_predicate different_user_queue_membership, :valid?

    different_channel_queue_membership = ChannelQueueMembership.new(channel_queue: ChannelQueue.create!(channel: 'different'), user: user)
    assert_predicate different_channel_queue_membership, :valid?
  end

  def test_belongs_to_channel_queue
    channel_queue = ChannelQueue.create!(channel: 'ev-chargers-of-appfolio')
    user = User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500)

    channel_queue_membership = ChannelQueueMembership.create!(channel_queue: channel_queue, user: user)

    assert_equal channel_queue, channel_queue_membership.channel_queue
  end

  def test_belongs_to_user
    channel_queue = ChannelQueue.create!(channel: 'ev-chargers-of-appfolio')
    user = User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500)

    channel_queue_membership = ChannelQueueMembership.create!(channel_queue: channel_queue, user: user)

    assert_equal user, channel_queue_membership.user
  end
end