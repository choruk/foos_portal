class GameJoiningService
  class UserAlreadyJoinedError < StandardError
  end

  def self.join(user)
    game_being_setup = Game.in_setup.first
    if game_being_setup
      #add user to game, but first check if they are already in it
      user_ids = game_being_setup.results.map(&:user_id)
      raise UserAlreadyJoinedError, "#{user} has already joined the current game being setup." if user_ids.include?(user.id)

      new_result = user.results.build
      new_result.game = game_being_setup
      new_result.save!

      game_being_setup.update_attributes!(started_at: Time.zone.now) if user_ids.length == 3
      game_being_setup
    else
      false
    end
  end
end
