require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  def test_validates_presence_of_user_and_game
    result = Result.new
    assert !result.valid?
    [:user, :game].each do |attr|
      assert_equal ["can't be blank"], result.errors[attr]
      result.send("#{attr}=", attr.to_s.capitalize.constantize.new)
      result.valid?
      assert result.errors[attr].blank?
    end
  end
end
