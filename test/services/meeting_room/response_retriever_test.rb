require 'test_helper'

module MeetingRoom
  class ResponseRetrieverTest < ActiveSupport::TestCase
    def test_retrieve
      assert_equal 'https://wpsvc5.com/ESASSO026/', MeetingRoom::ResponseRetriever.retrieve('map')

      expected_help_text = <<-help
        ```
          /meetingroom Camino --> direction how to go to meeting room Camino
          /meetingroom map    --> show floor plan map
        ```
      help
      assert_equal expected_help_text, MeetingRoom::ResponseRetriever.retrieve('help')

      assert_equal 'Sorry, room not found.', MeetingRoom::ResponseRetriever.retrieve('Del Sol')

      MeetingRoomDirection.create!(room_name: 'DelSol', direction: 'Go left and then go right.')

      assert_equal 'Del Sol - Go left and then go right.', MeetingRoom::ResponseRetriever.retrieve('Del Sol')
      MeetingRoomDirection.find_by(room_name: 'delsol').update!(notes: 'Maximum 6 people.')

      assert_equal 'del sol - Go left and then go right. Notes: Maximum 6 people.', MeetingRoom::ResponseRetriever.retrieve('del sol')
    end
  end
end
