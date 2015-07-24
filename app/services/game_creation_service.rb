class GameCreationService
  def self.create(user)
    game_being_setup = Game.in_setup.first
    game_in_progress = Game.in_progress.first
    if game_being_setup || game_in_progress
      #raise inprogress error? (or just return false)
      return false
    else
      #first person to setup new game
      new_game = Game.create!
      new_result = user.results.build
      new_result.game = new_game
      new_result.save!
      new_game
    end
  end
end
