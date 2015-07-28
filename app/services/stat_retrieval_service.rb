class StatRetrievalService
  def self.find(user)
    user_stats = {
      win_ratio: user.win_ratio,
      wins: user.games_won,
      losses: user.games_lost
    }

    return user_stats unless user.ranked?

    user_win_ratio_tuple = [win_ratio, user.slack_user_name]
    sorted_win_ratios = [user_win_ratio_tuple]
    User.where('id != ?', user.id).each do |other_user|
      next unless other_user.ranked?
      sorted_win_ratios.push [other_user.win_ratio, other_user.slack_user_name]
    end
    sorted_win_ratios.sort! { |x,y| x.first <=> y.first && x.last <=> y.last }
    user_stats[:rank] = sorted_win_ratios.index(user_win_ratio_tuple)+1
    user_stats
  end

  def self.rankings
    sorted_win_ratios = []
    User.all.each do |user|
      next unless user.ranked?
      sorted_win_ratios.push({ win_ratio: user.win_ratio, slack_name: user.slack_user_name, wins: user.games_won, losses: user.games_lost })
    end
    sorted_win_ratios.sort! { |x,y| x[:win_ratio] <=> y[:win_ratio] && x[:slack_name] <=> y[:slack_name] }
    sorted_win_ratios
  end
end
