class ChannelQueueMembership < ActiveRecord::Base
  belongs_to :channel_queue
  belongs_to :user

  validates_presence_of :user_id, :channel_queue_id
  validates :user_id, uniqueness: { scope: :channel_queue_id }
end
