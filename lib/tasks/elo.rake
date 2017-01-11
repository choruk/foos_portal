namespace :elo do
  desc "Recalculates elo scores from scratch using historic game records"
  task recalculate: :environment do
    User.all.each do |u|
      u.update_attribute(:rank, 1500)
    end
    Game.all.each do |g|
      RankingCalculatorService.rank(g)
    end
  end
end
