class ChannelQueue < ActiveRecord::Base
  has_many :channel_queue_memberships, -> { active }

  validates_presence_of :slack_channel_id, :slack_channel_name
  validates_uniqueness_of :slack_channel_id, :slack_channel_name

  def members_string
    user_names = channel_queue_memberships.order(created_at: :asc).joins(:user).pluck(:slack_user_name)
    return 'Queue is empty' if user_names.empty?

    formatted_response = user_names.each_with_index.map do |user_name, index|
      "#{index + 1}. #{user_name}"
    end.join("\n")

    "```#{formatted_response}```"
  end
end
