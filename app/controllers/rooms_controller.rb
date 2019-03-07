class RoomsController < ApplicationController
  def create
    room_direction = MeetingRoomDirection.where(room_name: create_params[:room_name].gsub(' ', '').downcase).first_or_initialize

    room_direction.direction = create_params[:direction]
    room_direction.notes = create_params[:notes]
    if room_direction.save
      render plain: "Update succeeded - Room: #{room_direction.room_name.capitalize}, Direction: #{room_direction.direction}, Notes: #{room_direction.notes}"
    else
      render plain: 'Update failed - please double check params.'
    end
  end

  def index
    room_name = index_params[:text]
    data = MeetingRoomDirection.where(room_name: room_name.gsub(' ', '').downcase).first
    if data.present?
      notes = data.notes.present? ? " Notes: #{data.notes}" : ''
      response = "#{room_name} - #{data.direction}#{notes}"
      render plain: response
    else
      render plain: 'Sorry, room not found.'
    end
  end
  
  private
  
  def index_params
    params.permit(:text)
  end

  def create_params
    params.permit(:room_name, :direction, :notes)
  end
end
