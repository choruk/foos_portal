class AddRankAndRankedToResults < ActiveRecord::Migration
  def change
    add_column :results, :rank, :integer
    add_column :results, :ranked, :boolean, null: false, default: false
  end
end
