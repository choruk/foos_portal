class GameQuittingService
  class UserNotInGameError < StandardError
  end

  class GameNotFoundError < StandardError
  end

  def self.quit(user)
    find_result = lambda do |game|
      result = game.results.find { |result| result.user_id == user.id }
      raise UserNotInGameError if result.nil?
      result
    end

    game_in_progress = Game.in_progress.includes(:results).first
    game_being_setup = Game.in_setup.includes(:results).first
    if game_in_progress
      result = find_result.call(game_in_progress)
      result.destroy
      game_in_progress.update_attributes!(started_at: nil)
      game_in_progress.reload
    elsif game_being_setup
      result = find_result.call(game_being_setup)
      result.destroy
      if game_being_setup.reload.all_players_quit?
        game_being_setup.destroy
      end
      return false
    else
      raise GameNotFoundError
    end
  end
end
