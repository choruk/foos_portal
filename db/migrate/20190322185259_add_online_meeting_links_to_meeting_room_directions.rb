class AddOnlineMeetingLinksToMeetingRoomDirections < ActiveRecord::Migration
  def up
    add_column :meeting_room_directions, :online_meeting_link, :string

    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/bodega' WHERE room_name = 'bodega';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/bosqueconference' WHERE room_name = 'bosque';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/caminoconference' WHERE room_name = 'camino';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/cieloconference' WHERE room_name = 'cielo';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/corazoncon' WHERE room_name = 'corazoncon';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/delsol' WHERE room_name = 'delsol';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/hermosa' WHERE room_name = 'hermosa';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/laspalmas' WHERE room_name = 'laspalmas';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/rincon' WHERE room_name = 'rincon';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/sombra' WHERE room_name = 'sombra';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET online_meeting_link = 'https://www.gotomeet.me/vistaconference' WHERE room_name = 'vista';
    SQL
  end

  def down
    remove_column :meeting_room_directions, :online_meeting_link
  end
end
