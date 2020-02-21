class ChannelQueueMembership < ActiveRecord::Base
  belongs_to :channel_queue
  belongs_to :user

  validates_presence_of :user_id, :channel_queue_id
  validates :user_id, uniqueness: { scope: :channel_queue_id }

  scope :active, -> { where('channel_queue_memberships.created_at >= ?', Time.now.in_time_zone('Pacific Time (US & Canada)').beginning_of_day + 7.hours)}
end
