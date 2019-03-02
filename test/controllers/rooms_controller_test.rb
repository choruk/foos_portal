require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  def test_show__found
    MeetingRoomDirection.create!(room_name: 'DelSol', direction: 'Go left and then go right.')

    get :show, id: 'Del Sol'
    assert_response :ok
    assert_equal 'Go left and then go right.', response.body

    get :show, id: 'DelSol'
    assert_response :ok
    assert_equal 'Go left and then go right.', response.body

    MeetingRoomDirection.create!(room_name: 'bodega', direction: 'Go right.', notes: 'Maximum 6 people')
    get :show, id: 'bodega'
    assert_response :ok
    assert_equal 'Go right. Notes: Maximum 6 people', response.body

  end

  def test_show__not_found
    get :show, id: 'Camino'

    assert_response :ok
    assert_equal 'Sorry, room not found.', response.body
  end

  def test_create__success__new_record
    assert_difference 'MeetingRoomDirection.count', 1 do
      post :create, { room_name: 'Camino', direction: 'Turn left', notes: 'Warmest room' }
    end

    assert_response :ok
    room = MeetingRoomDirection.last
    assert_equal 'camino', room.room_name
    assert_equal 'Turn left', room.direction
    assert_equal 'Warmest room', room.notes
  end

  def test_create__success__existing_record
    MeetingRoomDirection.create!(room_name: 'camino', direction: 'Go left and then go right.')

    assert_no_difference 'MeetingRoomDirection.count' do
      post :create, { room_name: 'Camino', direction: 'Turn left.', notes: 'Warmest room' }
    end

    assert_response :ok
    assert_equal 'Update succeeded - Room: Camino, Direction: Turn left., Notes: Warmest room', response.body
    room = MeetingRoomDirection.last
    assert_equal 'camino', room.room_name
    assert_equal 'Turn left.', room.direction
    assert_equal 'Warmest room', room.notes
  end

  def test_create_fail
    post :create, { room_name: 'Camino' }

    assert_response :ok
    assert_equal 'Update failed - please double check params.', response.body
  end
end
