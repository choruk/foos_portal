class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :finished_at
      t.boolean :abandoned, null: false, default: false

      t.timestamps
    end
  end
end
