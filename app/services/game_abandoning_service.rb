class GameAbandoningService
  def self.abandon
    game = Game.in_progress.first || Game.in_setup.first
    if game
      game.destroy
      true
    else
      false
    end
  end
end
