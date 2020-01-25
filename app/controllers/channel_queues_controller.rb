class ChannelQueuesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    response = ChannelQueues::ResponseRetriever.retrieve(params[:text], params[:channel_id], params[:channel_name], params[:user_id], params[:user_name])
    render json: response
  end
end
