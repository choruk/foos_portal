class ChannelQueueMembership < ActiveRecord::Base
  belongs_to :channel_queue
  belongs_to :user

  validates_presence_of :user_id, :channel_queue_id
  validates :user_id, uniqueness: { scope: :channel_queue_id }

  scope :active, -> { where('channel_queue_memberships.created_at >= ?', ChannelQueueMembership.queue_open_time)}
  scope :inactive, -> { where('channel_queue_memberships.created_at < ?', ChannelQueueMembership.queue_open_time)}

  def active?
    created_at >= ChannelQueueMembership.queue_open_time
  end

  def inactive?
    !active?
  end

  def self.queue_open_time
    Time.now.in_time_zone('Pacific Time (US & Canada)').beginning_of_day + 7.hours
  end
end
