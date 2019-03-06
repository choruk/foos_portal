require 'test_helper'

class MeetingRoomDirectionTest < ActiveSupport::TestCase
  def test_valid
    mrd1 = MeetingRoomDirection.new(room_name: 'Camino', direction: 'Go Right', notes: 'Max 6 people')
    assert_predicate mrd1, :valid?

    mrd2 = MeetingRoomDirection.new(room_name: 'Camino')
    refute_predicate mrd2, :valid?
    assert_equal "can't be blank", mrd2.errors.messages[:direction].first

    mrd3 = MeetingRoomDirection.new(direction: 'Go right')
    refute_predicate mrd3, :valid?
    assert_equal "can't be blank", mrd3.errors.messages[:room_name].first
  end
end
