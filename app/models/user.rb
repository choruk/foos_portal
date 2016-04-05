class User < ActiveRecord::Base
  has_many :results

  validates_presence_of :slack_user_id, :slack_user_name
  validates_uniqueness_of :slack_user_id

  def to_s
    slack_user_name
  end

  def mention
    "@#{slack_user_name}"
  end

  def mention_and_rank
    "#{mention} (#{rank})"
  end

  def games_finished
    results.finished.size
  end

  def games_won
    results.finished_wins.size
  end

  def win_ratio
    User.calculate_win_ratio(games_won, games_finished)
  end

  def games_lost
    games_finished - games_won
  end

  def self.calculate_win_ratio(won, finished)
    return 0 unless finished > 0
    (won.to_f / finished * 100).round(2)
  end
end
