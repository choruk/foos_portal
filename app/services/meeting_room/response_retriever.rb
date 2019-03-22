module MeetingRoom
  class ResponseRetriever
    FLOOR_MAP_URL = 'https://wpsvc5.com/ESASSO026/'.freeze
    private_constant :FLOOR_MAP_URL

    def self.retrieve(original_request_text)
      request = original_request_text.gsub(' ', '').downcase

      case request
      when 'map'
        return { text: "Click on this link to see a floorplan of the Appfolio offices #{FLOOR_MAP_URL}" }
      when 'list'
        rooms = MeetingRoomDirection.all.map do |room|
          "#{room.id}. #{room.room_name}"
        end.join("\n")

        response = <<-list
```
#{rooms}
```
        list

        return { text: response }
      when 'help'
        response = <<-help
        ```
/meetingroom Camino --> direction how to go to meeting room Camino
/meetingroom map    --> show floor plan map
/meetingroom list   --> show all meeting rooms name
        ```
        help

        return { text: response }
      else
        data = MeetingRoomDirection.where(room_name: request).first
        if data.present?
          notes = data.notes.present? ? " *Notes:* #{data.notes}" : ''
          online_meeting_link = data.online_meeting_link.present? ? " *GTM:* #{data.online_meeting_link}" : ''
          response = {
            text: "#{original_request_text} - #{data.direction}#{notes}#{online_meeting_link}",
            attachments: [
              {
                title: original_request_text,
                image_url: data.image
              }
            ]
          }
          return response
        else
          return { text: 'Sorry, room not found.' }
        end
      end
    end
  end
end
