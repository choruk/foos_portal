module ChannelQueues
  class NextInQueue
    attr_accessor :channel_queue

    def initialize(channel_id: nil, channel_name: nil, channel_queue: nil)
      return unless channel_id || channel_name || channel_queue

      @channel_queue = channel_queue || find_channel_queue(channel_id, channel_name)
    end

    def user_name
      user&.slack_user_name
    end

    def user_id
      user&.slack_user_id
    end

    private

    def user
      return if channel_queue.nil?

      first_membership = channel_queue.channel_queue_memberships.order(created_at: :asc).joins(:user).first
      return if first_membership.nil?

      return first_membership.user
    end

    def find_channel_queue(channel_id, channel_name)
      ChannelQueue.where(slack_channel_id: channel_id).first_or_create!(slack_channel_name: channel_name).tap do |channel_queue|
        # handle slack channel name changes
        channel_queue.update_attributes!(slack_channel_name: channel_name) if channel_queue.slack_channel_name != channel_name && channel_name.present?
      end
    end
  end
end
