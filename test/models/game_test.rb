require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def test_suggested_matchup
    users = [
      User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500),
      User.create!(slack_user_id: '2', slack_user_name: 'william', rank: 1400),
      User.create!(slack_user_id: '3', slack_user_name: 'jack', rank: 1300),
      User.create!(slack_user_id: '4', slack_user_name: 'averell', rank: 1200),
    ]
    @game = GameCreationService.create(users.pop)
    users.each do |user|
      @game = GameJoiningService.join(user)
    end

    assert_equal 'suggested matchup: @joe (1500) and @averell (1200) vs. @william (1400) and @jack (1300)', @game.suggested_matchup
  end
end
