class CreateMeetingRoomNameAndDirectionTable < ActiveRecord::Migration
  def change
    create_table :meeting_room_directions do |t|
      t.string :room_name, null: false
      t.text :direction, null: false
      t.text :notes

      t.timestamps
    end
  end
end
