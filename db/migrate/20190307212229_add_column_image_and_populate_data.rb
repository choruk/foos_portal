class AddColumnImageAndPopulateData < ActiveRecord::Migration
  def up
    add_column :meeting_room_directions, :image, :string, null: false

    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/MUi7Qfs.jpg' WHERE room_name = 'sombra'
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/k5rFAWD.jpg' WHERE room_name = 'delsol'
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/EQdWxiE.jpg' WHERE room_name = 'bodega';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/7lTdA3g.jpg' WHERE room_name = 'quietroom';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/OwQzh9a.jpg' WHERE room_name = 'mailroom';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/oreWQ6F.jpg' WHERE room_name = 'observationlounge2';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/Rff818j.jpg' WHERE room_name = 'observationlab';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/WT01UOV.jpg' WHERE room_name = 'vista';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/uyPuYTw.jpg' WHERE room_name = 'rincon';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/lDxGDTE.jpg' WHERE room_name = 'uxlab';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/guXdAtl.jpg' WHERE room_name = 'camino';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/L3y3u48.jpg' WHERE room_name = 'ellwood';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/y7ZtBJb.jpg' WHERE room_name = 'bosque';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/ZgNfFir.jpg' WHERE room_name = 'hermosa';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/cSjNFAJ.jpg' WHERE room_name = 'interviewroom1';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/zxrTcjX.jpg' WHERE room_name = 'interviewroom2';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/aYC3BQM.jpg' WHERE room_name = 'caliente';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/XvtK6FN.jpg' WHERE room_name = 'claro';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/pmG3P9j.jpg' WHERE room_name = 'centro';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/Hp5Rb7M.jpg' WHERE room_name = 'hacienda';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/tMfHwVK.jpg' WHERE room_name = 'cielo';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/EXIGmnd.jpg' WHERE room_name = 'sueno';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/OLcocQj.jpg' WHERE room_name = 'siesta';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/PgeL0ki.jpg' WHERE room_name = 'cocina';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/YwyI0V4.jpg' WHERE room_name = 'sttropez';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/aqC3onv.jpg' WHERE room_name = 'sansebastian';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/f7BlYf1.jpg' WHERE room_name = 'split';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/q4RuzGY.jpg' WHERE room_name = 'corazon';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/Pe6cEDy.jpg' WHERE room_name = 'motana';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/i4FvA7K.jpg' WHERE room_name = 'pequeno';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/n39R9mI.jpg' WHERE room_name = 'fiesta';
    SQL
    execute <<-SQL
      UPDATE meeting_room_directions SET image = 'https://i.imgur.com/E4insTe.jpg' WHERE room_name = 'laspalmas';
    SQL
  end

  def down
    remove_column :meeting_room_directions, :image
  end
end
