class PopulateDataFromBuilding50 < ActiveRecord::Migration
  def up
    execute <<-SQL
      INSERT INTO meeting_room_directions (room_name, direction, notes, created_at, updated_at)
      VALUES ('sombra', '50 Castilian, First Floor. Located in the southwest corner of the building. From the front entrance, enter left, then make your first right and go all the way to the end', NULL, NOW(), NOW()),
      ('delsol', '50 Castilian, First Floor. Located in the southwest corner of the building. From the front entrance, enter left, then make your first right and go all the way to the end', NULL, NOW(), NOW()),
      ('bodega', '50 Castilian, First Floor. From the front entrance, go left, then make your first right then the last right by Engineering Square. Bodega is the first room on your right.', NULL, NOW(), NOW()),
      ('quietroom', '50 Castilian, First Floor. From the front entrance, enter left, then make your first right then the last right by Engineering Square. The Quiet Room is the third room on your right.', 'Next to Alisha''s office', NOW(), NOW()),
      ('mailroom', '50 Castilian, First Floor. From the front entrance, enter left. It is the first room on your right.', NULL, NOW(), NOW()),
      ('observationlounge2', '50 Castilian, First Floor. From the front entrance, enter left. It is the third room on your right, immediately after the bathroom hallway.', NULL, NOW(), NOW()),
      ('observationlab', '50 Castilian, First Floor. From the front entrance, enter left. It is the second room on your right, after the bathroom hallway.', NULL, NOW(), NOW()),
      ('vista', '50 Castilian, First Floor. Located on the western side of the building. From the front entrance, enter left. It is the the large conference room on your left. ', NULL, NOW(), NOW()),
      ('rincon', '50 Castilian, First Floor. Located in the southeast corner of the building. From the front entrance, enter left, and walk straight. It is right after Vista, on your left.', NULL, NOW(), NOW()),
      ('uxLab', '50 Castilian, First Floor. From the front entrance, enter left. It is the third room on your right, after the bathroom hallway.', NULL, NOW(), NOW()),
      ('camino', '50 Castilian, First Floor. Located in the northwest corner of the building. From the front entrance, enter right and immediately turn left so you are walking down the long corridor. The room will be on your right before you reach the kitchen.', NULL, NOW(), NOW()),
      ('ellwood', '50 Castilian, First Floor. Located in the northwest corner of the building. From the front entrance, enter right and immediately turn left so you are walking down the long corridor. Make a right at Katy Pairy bay and the room will be the second on your left.', 'Next to Camino', NOW(), NOW()),
      ('bosque', '50 Castilian, First Floor. Located in the northwest corner of the building. From the front entrance, enter right and immediately turn left so you are walking down the long corridor. Make a right at Katy Pairy bay and the room will be the third on your left.', NULL, NOW(), NOW()),
      ('hermosa', '50 Castilian, First Floor. Located in the center of the north side of the building. From the front entrance, enter right and immediately turn left so you are walking down the long corridor. Make your second right, where Interview Room 2 is, and walk straight.', NULL, NOW(), NOW()),
      ('interviewroom1', '50 Castilian, First Floor. From the front entrance, enter right and immediately turn left so you are walking down the long corridor. Make your second right at Interview Room 2. It is the second room to your left.', 'Next to Interview Room 2', NOW(), NOW()),
      ('interviewroom2', '50 Castilian, First Floor. From the front entrance, enter right and immediately turn left so you are walking down the long corridor. It will be on your right, after the IT offices, at an intersection.', NULL, NOW(), NOW()),
      ('caliente', '50 Castilian, First Floor. From the front entrance, enter right then make a slight right and walk towards the northeast corner of the building. ', NULL, NOW(), NOW()),
      ('claro', '50 Castilian, Second Floor. Located in the northeast corner of the building. From the front entrance, go up the stairs and enter left. The room is straight ahead.', NULL, NOW(), NOW()),
      ('centro', '50 Castilian, Second Floor. From the front entrance, go up the stairs and enter left then an immediate left. Walk down the corridor  until you reach the turn of the kitchen. The room is on your left.', NULL, NOW(), NOW()),
      ('hacienda', '50 Castilian, Second Floor. From the front entrance, go up the stairs and enter right then an immediate right. Walk down the corridor until you reach the turn for the kitchen. The room is on your right.', NULL, NOW(), NOW()),
      ('cielo', '50 Castilian, Second Floor. It is located directly above Vista. From the front entrance, go up the stairs and enter right. It is immediately on your left.', NULL, NOW(), NOW())
    SQL
  end

  def down
    execute <<-SQL
      DELETE FROM meeting_room_directions;
    SQL
  end
end
