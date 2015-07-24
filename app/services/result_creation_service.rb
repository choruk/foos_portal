class ResultCreationService
  class NoGameInProgressError < StandardError
  end
  def self.create(user)
    game = Game.in_progress.includes(:results).first
    raise NoGameInProgressError if game.nil?

    result = game.results.find { |result| result.user_id == user.id }
    result.update_attributes!(win: true)

    if game.reload.finished?
      game.update_attributes!(finished_at: Time.zone.now)
    end
    result
  end
end
