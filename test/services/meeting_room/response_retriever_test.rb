require 'test_helper'

module MeetingRoom
  class ResponseRetrieverTest < ActiveSupport::TestCase
    def test_retrieve
      assert_equal 'https://wpsvc5.com/ESASSO026/', MeetingRoom::ResponseRetriever.retrieve('map')

      expected_help_text = <<-help
        ```
          /meetingroom Camino --> direction how to go to meeting room Camino
          /meetingroom map    --> show floor plan map
          /meetingroom list   --> show all meeting rooms name
        ```
      help
      assert_equal expected_help_text, MeetingRoom::ResponseRetriever.retrieve('help')

      assert_equal 'Sorry, room not found.', MeetingRoom::ResponseRetriever.retrieve('Del Sol')

      delsol = MeetingRoomDirection.create!(room_name: 'delsol', direction: 'Go left and then go right.')

      assert_equal 'Del Sol - Go left and then go right.', MeetingRoom::ResponseRetriever.retrieve('Del Sol')
      MeetingRoomDirection.find_by(room_name: 'delsol').update!(notes: 'Maximum 6 people.')

      assert_equal 'del sol - Go left and then go right. *Notes:* Maximum 6 people.', MeetingRoom::ResponseRetriever.retrieve('del sol')

      camino = MeetingRoomDirection.create!(room_name: 'camino', direction: 'Go left.')
      bodega = MeetingRoomDirection.create!(room_name: 'bodega', direction: 'Go right.')

      expected_list = <<-list
        ```
          #{delsol.id}. delsol
#{camino.id}. camino
#{bodega.id}. bodega
        ```
      list
      assert_equal expected_list, MeetingRoom::ResponseRetriever.retrieve('list')
    end
  end
end
