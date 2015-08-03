class RankingCalculatorService
  class << self
    K_VALUE = 32

    def rank(game)
      return unless game.finished?

      winners = game.winning_team
      losers = game.losing_team

      # Each player is said to have played against the average elo of the
      #   opposing team.
      winner_elo = winners.map(&:elo_rating).inject(:+) / 2
      loser_elo = losers.map(&:elo_rating).inject(:+) / 2

      winners.each do |winner|
        winner.update_attributes!(elo_rating: new_elo(winner.elo_rating, loser_elo, 1))
      end

      losers.each do |loser|
        loser.update_attributes!(elo_rating: new_elo(loser.elo_rating, winner_elo, 0))
      end
    end

    private

    def new_elo(player_rank, opponent_rank, score)
      (player_rank + K_VALUE * (score - expected_score(player_rank, opponent_rank))).round
    end

    def expected_score(player_rank, opponent_rank)
      q(player_rank).to_f / (q(player_rank) + q(opponent_rank))
    end

    def q(rank)
      10**(rank.to_f / 400)
    end
  end
end
