class StatRetrievalService
  def self.find(user)
    win_ratio = user.games_won.to_f / user.games_finished.to_f
    user_stats = {
      win_ratio: win_ratio
    }

    sorted_win_ratios = [[win_ratio, user.id]]
    User.where('id != ?', user.id).each do |other_user|
      user_win_ratio = other_user.games_won.to_f / other_user.games_finished.to_f
      sorted_win_ratios.push [user_win_ratio, other_user.id]
    end
    sorted_win_ratios.sort!
    user_stats[:rank] = sorted_win_ratios.index([win_ratio, user.id])+1

    user_stats
  end
end
