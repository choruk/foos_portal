require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  def test_index__found
    MeetingRoomDirection.create!(room_name: 'DelSol', direction: 'Go left and then go right.', image: 'example.com/test.jpg')

    get :index, { text: 'Del Sol', token: '12345' }
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal 'Del Sol - Go left and then go right.', body['text']
    assert_equal 'Del Sol', body['attachments'].first['title']
    assert_equal 'example.com/test.jpg', body['attachments'].first['image_url']

    MeetingRoomDirection.create!(room_name: 'bodega', direction: 'Go right.', notes: 'Maximum 6 people', image: 'example.com/test.jpg')
    get :index, { text: 'bodega', token: '12345' }
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal 'bodega - Go right. *Notes:* Maximum 6 people', body['text']
    assert_equal 'bodega', body['attachments'].first['title']
    assert_equal 'example.com/test.jpg', body['attachments'].first['image_url']
  end

  def test_index__not_found
    get :index, { text: 'camino', token: '12345' }

    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal 'Sorry, room not found.', body['text']
  end

  def test_create__success__new_record
    MeetingRoomDirection.destroy_all
    assert_difference 'MeetingRoomDirection.count', 1 do
      post :create, { room_name: 'Camino', direction: 'Turn left', notes: 'Warmest room', image: 'example.com/test.jpg' }
    end

    assert_response :ok
    body = JSON.parse(response.body)

    assert_equal 'Update succeeded - Room: Camino, Direction: Turn left, *Notes:* Warmest room. example.com/test.jpg', body['text']
    room = MeetingRoomDirection.last
    assert_equal 'camino', room.room_name
    assert_equal 'Turn left', room.direction
    assert_equal 'Warmest room', room.notes
    assert_equal 'example.com/test.jpg', room.image
  end

  def test_create__success__existing_record
    MeetingRoomDirection.create!(room_name: 'camino', direction: 'Go left and then go right.', image: 'example.com/test.jpg')

    assert_no_difference 'MeetingRoomDirection.count' do
      post :create, { room_name: 'Camino', notes: 'Warmest room' }
    end

    assert_response :ok
    body = JSON.parse(response.body)

    assert_equal 'Update succeeded - Room: Camino, Direction: Go left and then go right., *Notes:* Warmest room. example.com/test.jpg', body['text']
    room = MeetingRoomDirection.last
    assert_equal 'camino', room.room_name
    assert_equal 'Go left and then go right.', room.direction
    assert_equal 'Warmest room', room.notes
    assert_equal 'example.com/test.jpg', room.image
  end

  def test_create_fail
    post :create, { room_name: 'Camino' }

    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal 'Update failed - please double check params.', body['text']
  end
end
