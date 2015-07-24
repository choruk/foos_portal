class SlackCoordinatorController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :receive
  # This will be the action that gets hit by slack when
  # someone uses the trigger word in the right channel.
  def receive
    puts params

    render json: { text: 'Yea I heard you' }
  end
end
