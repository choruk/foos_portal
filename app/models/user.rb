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
    games_finished > 0 ? games_won.to_f / games_finished.to_f : 0
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
end
