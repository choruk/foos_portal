module ChannelQueues
  class ResponseRetriever
    ALL_COMMANDS = {
      'list' => 'show current queue in order from first to last',
      'join' => 'join the queue',
      'leave' => 'leave the queue',
      'charging' => 'leave the queue',
    }.freeze

    def self.retrieve(original_request_text, channel_id, channel_name, user_id, user_name)
      channel_queue = find_channel_queue(channel_id, channel_name)

      request = original_request_text.gsub(' ', '').downcase

      case request
      when 'list'
        return { text: channel_queue.members_string }
      when 'join'
        user = find_user(user_id, user_name)
        return { text: "#{user.slack_user_name} already in queue for #{channel_queue.slack_channel_name}." } if ChannelQueueMembership.where(user: user, channel_queue: channel_queue).exists?

        ChannelQueueMembership.create!(user: user, channel_queue: channel_queue)
        return { text: "#{user.slack_user_name} joined queue for #{channel_queue.slack_channel_name}." }
      when 'leave', 'charging'
        user = find_user(user_id, user_name)

        text = "#{user.slack_user_name} has left queue for #{channel_queue.slack_channel_name}."

        ChannelQueueMembership.where(user: user, channel_queue: channel_queue).destroy_all

        return { text: text }
      when 'help'
        json_result = {}
        json_result[:text] = ALL_COMMANDS.map do |command, description|
          "_/queue #{command}_\t\t#{description}"
        end.join("\n")

        return json_result
      else
        return { text: 'Sorry, command not recognized.' }
      end
    end

    private

    def self.find_channel_queue(channel_id, channel_name)
      ChannelQueue.where(slack_channel_id: channel_id).first_or_create!(slack_channel_name: channel_name).tap do |channel_queue|
        # handle slack channel name changes
        channel_queue.update_attributes!(slack_channel_name: channel_name) if channel_queue.slack_channel_name != channel_name && channel_name.present?
      end
    end

    def self.find_user(user_id, user_name)
      User.where(slack_user_id: user_id).first_or_create!(slack_user_name: user_name).tap do |user|
        # handle people changing their slack username
        user.update_attributes!(slack_user_name: user_name) if user.slack_user_name != user_name && user_name.present?
      end
    end
  end
end
