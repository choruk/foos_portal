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
end
