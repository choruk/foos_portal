require 'test_helper'

module MeetingRoom
  class ResponseRetrieverTest < ActiveSupport::TestCase
    def test_retrieve
      expected_reponse = { text: 'Click on this link to see a floorplan of the Appfolio offices https://wpsvc5.com/ESASSO026/' }
      assert_equal expected_reponse, MeetingRoom::ResponseRetriever.retrieve('map')

      expected_help_text = <<-help
        ```
/meetingroom Camino --> direction how to go to meeting room Camino
/meetingroom map    --> show floor plan map
/meetingroom list   --> show all meeting rooms name
        ```
      help

      expected_response = { text: expected_help_text }
      assert_equal expected_response, MeetingRoom::ResponseRetriever.retrieve('help')

      expected_response = { text: 'Sorry, room not found.' }
      assert_equal expected_response, MeetingRoom::ResponseRetriever.retrieve('Del Sol')

      delsol = MeetingRoomDirection.create!(room_name: 'delsol', direction: 'Go left and then go right.', image: 'example.com/test.jpg')

      expected_reponse = {
        text: 'Del Sol - Go left and then go right.',
        attachments: [
          {
            title: 'Del Sol',
            image_url: 'example.com/test.jpg'
          }
        ]
      }
      assert_equal expected_reponse, MeetingRoom::ResponseRetriever.retrieve('Del Sol')
      MeetingRoomDirection.find_by(room_name: 'delsol').update!(notes: 'Maximum 6 people.')

      expected_reponse = {
        text: 'del sol - Go left and then go right. *Notes:* Maximum 6 people.',
        attachments: [
          {
            title: 'del sol',
            image_url: 'example.com/test.jpg'
          }
        ]
      }

      assert_equal expected_reponse, MeetingRoom::ResponseRetriever.retrieve('del sol')

      camino = MeetingRoomDirection.create!(room_name: 'camino', direction: 'Go left.', image: 'example.com/test.jpg')
      bodega = MeetingRoomDirection.create!(room_name: 'bodega', direction: 'Go right.', image: 'example.com/test.jpg')

      expected_list = <<-list
```
#{delsol.id}. delsol
#{camino.id}. camino
#{bodega.id}. bodega
```
      list
      expected_reponse = { text: expected_list }
      assert_equal expected_reponse, MeetingRoom::ResponseRetriever.retrieve('list')
    end
  end
end
