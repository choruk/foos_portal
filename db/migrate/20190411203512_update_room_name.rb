class UpdateRoomName < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE meeting_room_directions SET room_name = 'montana' WHERE room_name = 'motana';
    SQL
  end

  def down
    execute <<-SQL
      UPDATE meeting_room_directions SET room_name = 'motana' WHERE room_name = 'montana';
    SQL
  end
end
