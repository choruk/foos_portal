class UpdateMeetingRooms < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE meeting_room_directions SET room_name = 'observationlounge1' WHERE room_name = 'observationlab';
    SQL

    execute <<-SQL
      UPDATE meeting_room_directions SET room_name = 'traditions', image = 'https://imgur.com/kxn5cXn.jpg' WHERE room_name = 'interviewroom1';
    SQL

    execute <<-SQL
      UPDATE meeting_room_directions SET room_name = 'values', image = 'https://imgur.com/woFddzV.jpg' WHERE room_name = 'interviewroom2';
    SQL
  end
end
