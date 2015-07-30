class StatRetrievalService
  def self.find(user)
    user_stats = {
      win_ratio: user.win_ratio,
      wins: user.games_won,
      losses: user.games_lost
    }

    return user_stats unless user.ranked?

    user_stats[:rank] = rankings.find { |user_stats| user_stats[:slack_name] == user.slack_user_name }[:rank]
    user_stats
  end

  def self.rankings
    sorted_win_ratios = []
    User.all.each do |user|
      next unless user.ranked?
      sorted_win_ratios.push({ win_ratio: user.win_ratio, slack_name: user.slack_user_name, wins: user.games_won, losses: user.games_lost })
    end
    sorted_win_ratios.sort! { |x,y| y[:win_ratio] <=> x[:win_ratio] }
    determine_ranks(sorted_win_ratios)
  end

  ####PRIVATE METHODS####

  def self.determine_ranks(sorted_user_win_ratios)
    previous_win_ratio = -1
    current_rank = 0
    players_at_rank = 1
    sorted_user_win_ratios.each do |user_win_ratio_hash|
      if user_win_ratio_hash[:win_ratio] != previous_win_ratio
        current_rank += players_at_rank
        players_at_rank = 0
        previous_win_ratio = user_win_ratio_hash[:win_ratio]
      end

      user_win_ratio_hash[:rank] = current_rank
      players_at_rank += 1
    end
  end
  private_class_method :determine_ranks
end
