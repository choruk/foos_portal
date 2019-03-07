class InsertDataWithMoreRooms < ActiveRecord::Migration
  def up
    execute <<-SQL
      INSERT INTO meeting_room_directions (room_name, direction, notes, created_at, updated_at)
      VALUES ('sueno', '90 Castilian, First Floor. From the main entrance, enter left and then walk straight through another door.  Walk straight and the room is head of you, slightly to the right.', 'Next to Siesta', NOW(), NOW()),
      ('siesta', '90 Castilian, First Floor. From the main entrance, enter left and then walk straight through another door.  Walk straight and the room is head of you, slightly to the right.', 'Next to Sueno', NOW(), NOW()),
      ('cocina', '90 Castilian, First Floor. From the main entrance, enter left and walk straight, pass the restrooms. The room will be on your right.', NULL, NOW(), NOW()),
      ('sttropez', '90 Castilian, First Floor. Located on the west side of the building. From the main entrance, enter right and it is on your right.', NULL, NOW(), NOW()),
      ('sansebastian', '90 Castilian, First Floor. Located in the southwestern corner of the building. From the main entrance, enter right and walk to the corner. It is on your right.', NULL, NOW(), NOW()),
      ('split', '90 Castilian, First Floor. Located on the east side of the building. From the main entrance, enter right and make your first left. Walk along the pathway, passing the kitchen on your left. Split is on the other side of the building.', NULL, NOW(), NOW()),
      ('corazon', '90 Castilian, First Floor. Located on the east side of the building. From the main entrance, enter left and walk down the hallway. The room is the last on your left.', NULL, NOW(), NOW()),
      ('motana', '90 Castilian, Second Floor. Located on the west side of the building. From the main entrance, go up the stairs and enter right. The room is on your immediate left.', NULL, NOW(), NOW()),
      ('pequeno', '90 Castilian, Second Floor. Located on the west side of the building. From the main entrance, go up the stairs and enter right.  Make your first right and snake your way through the kitchen. Make a right and it''s immediately on your right.', NULL, NOW(), NOW()),
      ('fiesta', '90 Castilian, Second Floor. Located on the west side of the building. From the main entrance, go up the stairs and enter left. The room is the last one on your right.', NULL, NOW(), NOW()),
      ('laspalmas', '90 Castilian, Second Floor. Located in the southeastern side of the building. From the main entrance, go up the stairs and enter left. Make your first left and walk down the corridor, passing the kitchen on your left, until you reach the eastern wall. Make a right and the room is the last one in your left, in a corner.', NULL, NOW(), NOW())
    SQL

    execute <<-SQL
      UPDATE meeting_room_directions
      SET room_name = 'uxlab'
      WHERE room_name = 'uxLab'
    SQL
  end

  def down
    execute <<-SQL
      DELETE FROM meeting_room_directions 
      WHERE room_name in ('sueno', 'siesta', 'cocina', 'sttropez', 'sansebastian', 'split', 'corazon', 'motana', 'pequeno', 'fiesta', 'laspalmas');
    SQL

    execute <<-SQL
      UPDATE meeting_room_directions
      SET room_name = 'uxLab'
      WHERE room_name = 'uxlab'
    SQL
  end
end
