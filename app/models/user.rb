class User < ActiveRecord::Base
  has_many :results

  validates :slack_user_id, :slack_user_name, presence: true
  validates :slack_user_id, uniqueness: true

  def to_s
    slack_user_name
  end

  def mention
    "<@#{slack_user_id}|#{slack_user_name}>"
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

  def stale?
    return true if results.empty?
    results.order(created_at: :desc).first.created_at < Time.now.utc - 2.weeks
  end
end
