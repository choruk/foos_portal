class User < ActiveRecord::Base
  GAMES_NEEDED_TO_RANK = 5

  has_many :results

  validates_presence_of :slack_user_id, :slack_user_name

  def to_s
    slack_user_name
  end

  def games_finished
    results.finished.size
  end

  def games_won
    results.wins.size
  end

  def win_ratio
    User.calculate_win_ratio(games_won, games_finished)
  end

  def games_lost
    games_finished - games_won
  end

  def ranked?
    games_finished >= GAMES_NEEDED_TO_RANK
  end

  def games_needed_to_rank
    games_finished >= GAMES_NEEDED_TO_RANK ? 0 : GAMES_NEEDED_TO_RANK - games_finished
  end

  def self.calculate_win_ratio(won, finished)
    return 0 unless finished > 0
    (won.to_f / finished * 100).round(2)
  end
end
