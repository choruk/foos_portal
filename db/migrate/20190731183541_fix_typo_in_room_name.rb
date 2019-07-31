class FixTypoInRoomName < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE meeting_room_directions SET room_name = 'clarendon' WHERE room_name = 'claredon';
    SQL
  end

  def down
    execute <<-SQL
      UPDATE meeting_room_directions SET room_name = 'claredon' WHERE room_name = 'clarendon';
    SQL
  end
end
