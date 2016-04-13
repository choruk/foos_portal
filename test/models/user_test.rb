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
end
