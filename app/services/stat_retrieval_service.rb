class StatRetrievalService
  class << self
    def find(user)
      wins = user.games_won
      losses = user.games_lost
      {
        rank: user.rank,
        win_ratio: User.calculate_win_ratio(wins, wins + losses),
        wins: wins,
        losses: losses
      }
    end

    def stats_string(user)
      user_stats = find(user)
      ["Elo Rank: #{user_stats[:rank]}",
       "Wins: #{user_stats[:wins]}\tLosses: #{user_stats[:losses]}",
       "#{user} has won #{user_stats[:win_ratio]}% of the games they have finished."]
        .join("\n")
    end

    def rankings(limit: 1000)
      ranked_users = []
      User.where('rank != 1500').order('rank desc').limit(limit).each do |u|
        wins = u.games_won
        losses = u.games_lost
        win_ratio = User.calculate_win_ratio(wins, wins + losses)

        ranked_users << { slack_name: u.slack_user_name,
                          rank: u.rank,
                          wins: wins,
                          losses: losses,
                          win_ratio: win_ratio }
      end
      ranked_users
    end

    def rankings_string(limit: 1000)
      result = ''
      rankings(limit: limit).each do |r|
        result += [r[:rank],
                   r[:slack_name],
                   "#{r[:wins]}-#{r[:losses]}"].join("\t")
        result += "\n"
      end
      result
    end
  end
end
