class GameCreationService
  class GameInProgressError < StandardError
    attr_reader :game
    def initialize(game)
      @game = game
    end
  end

  class GameInSetupError < StandardError
    attr_reader :game
    def initialize(game)
      @game = game
    end
  end

  def self.create(user)
    game_being_setup = Game.in_setup.first
    game_in_progress = Game.in_progress.first
    raise GameInProgressError.new(game_in_progress) if game_in_progress
    raise GameInSetupError.new(game_being_setup) if game_being_setup

    #first person to setup new game
    new_game = Game.create!
    new_result = user.results.build
    new_result.game = new_game
    new_result.save!
    new_game
  end
end
