class RoomsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    room_direction = MeetingRoomDirection.where(room_name: create_params[:room_name].gsub(' ', '').downcase).first_or_initialize

    room_direction.direction = create_params[:direction] if create_params[:direction].present?
    room_direction.notes = create_params[:notes] if create_params[:notes].present?
    if room_direction.save
      render plain: "Update succeeded - Room: #{room_direction.room_name.capitalize}, Direction: #{room_direction.direction}, Notes: #{room_direction.notes}"
    else
      render plain: 'Update failed - please double check params.'
    end
  end

  def index
    response = MeetingRoom::ResponseRetriever.retrieve(index_params[:text])
    render plain: response
  end
  
  private
  
  def index_params
    params.permit(:text)
  end

  def create_params
    params.permit(:room_name, :direction, :notes)
  end
end
