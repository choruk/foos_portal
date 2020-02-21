module ChannelQueues
  class ResponseRetriever
    ALL_COMMANDS = {
      'list' => 'show current queue in order from first to last',
      'list blast' => 'show current queue (to whole channel) in order from first to last',
      'join' => 'join the queue',
      'leave' => 'leave the queue',
      'charging' => 'leave the queue',
      'moved' => 'notify the next in the queue of an open spot',
      'open' => 'notify the next in the queue of an open spot',
    }.freeze

    def self.retrieve(original_request_text, channel_id, channel_name, user_id, user_name)
      json_result = { response_type: 'ephemeral' }
      channel_queue = find_channel_queue(channel_id, channel_name)

      request = original_request_text.downcase

      case request
      when 'list blast'
        json_result[:text] = channel_queue.members_string
        json_result[:response_type] = 'in_channel'
      when 'list'
        json_result[:text] = channel_queue.members_string
      when 'join'
        user = find_user(user_id, user_name)
        if ChannelQueueMembership.where(user: user, channel_queue: channel_queue).exists?
          json_result[:text] = "#{user.slack_user_name} already in queue for #{channel_queue.slack_channel_name}."
          return json_result
        end

        ChannelQueueMembership.create!(user: user, channel_queue: channel_queue)
        json_result[:text] = "#{user.slack_user_name} joined queue for #{channel_queue.slack_channel_name}."
        json_result[:response_type] = 'in_channel'
      when 'leave', 'charging'
        user = find_user(user_id, user_name)

        json_result[:text] = "#{user.slack_user_name} has left queue for #{channel_queue.slack_channel_name}."

        return json_result unless ChannelQueueMembership.where(user: user, channel_queue: channel_queue).exists?

        ChannelQueueMembership.where(user: user, channel_queue: channel_queue).destroy_all

        json_result[:response_type] = 'in_channel'
      when 'moved', 'open'
        next_in_queue_id = NextInQueue.new(channel_queue: channel_queue).user_id

        if next_in_queue_id.nil?
          json_result[:text] = 'Queue is empty.'
          return json_result
        end

        json_result[:text] = ''

        if request == 'moved'
          json_result[:text] << "#{find_user(user_id, user_name).slack_user_name} has moved."
        else
          json_result[:text] << 'A spot is open.'
        end

        json_result[:text] << " <@#{next_in_queue_id}> is next in line. Please dequeue when you get a spot with `/queue charging`."
        json_result[:response_type] = 'in_channel'
      when 'help'
        json_result[:text] = ALL_COMMANDS.map do |command, description|
          "_/queue #{command}_\t\t#{description}"
        end.join("\n")
      else
        json_result[:text] = 'Sorry, command not recognized.'
      end

      return json_result
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
