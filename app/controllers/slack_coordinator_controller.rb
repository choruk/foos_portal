class SlackCoordinatorController < ApplicationController
  # This will be the action that gets hit by slack when
  # someone uses the trigger word in the right channel.
  def receive
    puts params
  end
end
