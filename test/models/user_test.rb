require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_validates_presence_of_slack_user_id_and_name
    u = User.new
    u.valid?
    [:slack_user_id, :slack_user_name].each do |attr|
      assert_equal ["can't be blank"], u.errors[attr]
      u.send("#{attr}=", 'stringz')
      u.valid?
      assert u.errors[attr].blank?
    end
  end

  def test_mention
    u = User.new slack_user_name: 'bob', slack_user_id: '1234'

    assert_equal '<@1234|bob>', u.mention
  end

  def test_stale
    u_old = User.create!(slack_user_id: 123, slack_user_name: 123)
    u_new = User.create!(slack_user_id: 456, slack_user_name: 456)

    Result.create!(user: u_old, game: Game.create!, created_at: Time.now - 1.month)
    5.times { Result.create!(user: u_new, game: Game.create!) }

    assert u_old.unranked?
    refute u_new.unranked?
  end
end
