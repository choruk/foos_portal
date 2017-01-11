class RankingCalculatorService
  class << self
    def rank(game)
      return unless game.finished?

      winners = game.winning_team
      losers = game.losing_team
      old_ranks = game.players.map { |p| [p, p.rank] }.to_h

      update_player(winners[0], winners[1], losers[0], losers[1], 1, old_ranks)
      update_player(winners[1], winners[0], losers[0], losers[1], 1, old_ranks)

      update_player(losers[0], losers[1], winners[0], winners[1], 0, old_ranks)
      update_player(losers[1], losers[0], winners[0], winners[1], 0, old_ranks)
    end

    private

    def update_player(player, teammate, opponent_1, opponent_2, score, old_ranks)
      # To account for the rank of the teammate, we sum the opponents then
      #   subtract the rank of the teammate. This way, playing with a lower
      #   ranked teammate counts as a more challenging game and vice versa.
      o_rank = old_ranks[opponent_1] + old_ranks[opponent_2] - old_ranks[teammate]

      player.update_attributes!(rank: new_elo(old_ranks[player], o_rank, score))
    end

    def new_elo(player_rank, opponent_rank, score)
      # The player's ranking is affected by the K Factor times the chance they
      #   had of winning minus the actual result. E.g. if a player has a .75
      #   chance of winning, a K Factor of 32, and loses, they will lose 24
      #   points.
      (player_rank + k_factor(player_rank) *
        (score - expected_score(player_rank, opponent_rank))).round
    end

    def expected_score(player_rank, opponent_rank)
      # This determines, on a scale from 0.0 to 1.0, the chances a player has
      #   of defeating a given opponent. This is used to determine what
      #   percentage of the K Factor is applied or taken away at the end of
      #   a match.
      q(player_rank).to_f / (q(player_rank) + q(opponent_rank))
    end

    def q(rank)
      # 400 is arbitrary, but seems to be pretty universal among all the
      #   implementations of Elo's ranking system I've come across.
      10**(rank.to_f / 400)
    end

    def k_factor(player_rank)
      # The K factor is the maximum value by which a given player's rating
      #   can change in a given match. We will use USCF's logistic distribution
      #   for determining K factor based on rating.
      if player_rank < 2100
        32
      elsif player_rank < 2400
        24
      else
        16
      end
    end
  end
end
