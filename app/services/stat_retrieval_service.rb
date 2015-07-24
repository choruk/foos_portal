class StatRetrievalService
  def self.find(user)
    win_ratio = user.games_won.to_f / user.games_finished.to_f
    user_stats = {
      win_ratio: win_ratio,
      wins: user.games_won,
      losses: user.games_finished - user.games_won
    }

    unless user.ranked? < User::GAMES_NEEDED_TO_RANK
      user_stats[:unranked] = User::GAMES_NEEDED_TO_RANK - user.results.size
      return user_stats
    end

    sorted_win_ratios = [[win_ratio, user.slack_user_name]]
    User.where('id != ?', user.id).each do |other_user|
      next unless other_user.ranked?
      user_win_ratio = other_user.games_won.to_f / other_user.games_finished.to_f
      sorted_win_ratios.push [user_win_ratio, other_user.slack_user_name]
    end
    sorted_win_ratios.sort! { |x,y| x.first <=> y.first && x.last <=> y.last }
    user_stats[:rank] = sorted_win_ratios.index([win_ratio, user.slack_user_name])+1
    user_stats
  end
end
