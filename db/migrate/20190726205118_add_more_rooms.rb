class AddMoreRooms < ActiveRecord::Migration
  def up
    execute <<-SQL
      INSERT INTO meeting_room_directions (room_name, direction, notes, image, created_at, updated_at)
      VALUES ('renaissance', '130 Castilian. From the main entrance, walk straight ahead and turn left. The room is immediately on your right.', NULL, 'https://i.imgur.com/qUmwJUs.jpg', NOW(), NOW()),
      ('claredon', '130 Castilian. From the main entrance, walk straight ahead and turn left. Make your next left then another left. Walk straight ahead and the room is at the end, next Granada.', NULL, 'https://i.imgur.com/dWtfG0u.jpg', NOW(), NOW()),
      ('symphony', '130 Castilian. From the main entrance, walk in and make a right. Make your way to opposite wall and the room is on your right.', NULL, 'https://i.imgur.com/6YabScX.jpg', NOW(), NOW()),
      ('kellogg', '50 Castilian, First Floor. Located near the mailroom. From the front entrance, enter left and immediately turn right, heading towards Engineering Square. Kellogg will be on your right, after the mailroom.', NULL, 'https://i.imgur.com/id8q546.jpg', NOW(), NOW()),
      ('focusroom1', '50 Castilian, Second Floor. Located in the southwest corner of the building. From the front entrance, go up the stairs and enter right. Make your first right and walk down the corridor and turn the corner after Hacienda. The entrance is on your immediate right.', 'Next to Focus Room 2', 'https://i.imgur.com/K1UgD4S.jpg', NOW(), NOW()),
      ('focusroom2', '50 Castilian, Second Floor. Located in the southwest corner of the building. From the front entrance, go up the stairs and enter right. Make your first right and walk down the corridor and turn the corner after Hacienda. The entrance is on your immediate right.', 'Next to Focus Room 1', 'https://i.imgur.com/K1UgD4S.jpg', NOW(), NOW())
    SQL
  end

  def down
    execute <<-SQL
      DELETE FROM meeting_room_directions WHERE room_name IN ('renaissance', 'claredon', 'symphony', 'kellogg', 'focusroom1', 'focusroom2');
    SQL
  end
end
