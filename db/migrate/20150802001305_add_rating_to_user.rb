class AddRatingToUser < ActiveRecord::Migration
  def change
    add_column :users, :elo_rating, :integer, null: false, default: 1500
  end
end
