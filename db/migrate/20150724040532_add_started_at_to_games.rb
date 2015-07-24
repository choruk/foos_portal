class AddStartedAtToGames < ActiveRecord::Migration
  def change
    add_column :games, :started_at, :datetime
  end
end
