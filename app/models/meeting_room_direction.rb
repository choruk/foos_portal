class MeetingRoomDirection < ActiveRecord::Base
  validates_presence_of :room_name, :direction, :image
end
