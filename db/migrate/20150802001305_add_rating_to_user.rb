class AddRatingToUser < ActiveRecord::Migration
  def up
    add_column :users, :rank, :integer, null: false, default: 1500

    Game.order(:started_at).each { |g| RankingCalculatorService.rank(g) }
  end

  def down
    remove_column :users, :rank
  end
end
