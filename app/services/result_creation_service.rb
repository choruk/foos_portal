class ResultCreationService
  class NoGameInProgressError < StandardError
  end

  class ResultAlreadyRecordedError < StandardError
  end

  def self.create(user)
    game = Game.in_progress.includes(:results).first
    raise NoGameInProgressError if game.nil?

    result = game.results.find { |result| result.user_id == user.id }
    raise ResultAlreadyRecordedError if result.win?

    result.update_attributes!(win: true)

    if game.reload.finished?
      game.update_attributes!(finished_at: Time.zone.now)

      RankingCalculatorService.rank(game)
      user.reload

      result.update_attributes!(rank: user.rank, ranked: true)
    end

    result
  end
end
