require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def test_suggested_matchup
    users = [
      User.create!(slack_user_id: '1', slack_user_name: 'joe', rank: 1500),
      User.create!(slack_user_id: '2', slack_user_name: 'william', rank: 1400),
      User.create!(slack_user_id: '3', slack_user_name: 'jack', rank: 1300),
      User.create!(slack_user_id: '4', slack_user_name: 'averell', rank: 1200),
    ]

    5.times do
      GameCreationService.create(users.first)
      users.each do |user|
        next if user == users.first
        GameJoiningService.join(user)
      end
      ResultCreationService.create(users.first)
      ResultCreationService.create(users.second)
    end

    @game = GameCreationService.create(users.pop)
    users.each do |user|
      @game = GameJoiningService.join(user)
    end

    assert_equal 'suggested matchup: <@1|joe> (1513) and <@4|averell> (1187) vs. <@2|william> (1413) and <@3|jack> (1287)', @game.suggested_matchup
  end

  def test_suggested_matchup__unranked
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

    assert_equal 'No suggested matchup because not all players have played 5 games', @game.suggested_matchup
  end
end
