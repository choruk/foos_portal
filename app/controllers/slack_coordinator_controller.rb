class SlackCoordinatorController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :receive

  before_filter :find_user

  # This will be the action that gets hit by slack when
  # someone uses the trigger word in the right channel.
  def receive
    puts params

    result = { text: 'Yea I heard you' }
    case command_message
    when 'now'
      puts '***************STARTING GAME***************'
      game = GameCreationService.create(@user)
      if game
        result[:text] = "#{@user} is starting a new game. Need 3 more."
      else
        result[:text] = 'Game currently in progress.'
      end
    when 'in'
      puts '***************USER WANTS TO JOIN***************'
      begin
        game = GameJoiningService.join(@user)
        if game
          if game.in_progress?
            result[:text] = "#{@user} has joined the game.\nTTT"
          else
            result[:text] = "#{@user} has successfully joined the game. Need #{game.players_needed} more."
          end
        else
          result[:text] = 'No game could be joined.'
        end
      rescue UserAlreadyJoinedError
        result[:text] = "#{@user} has already joined the game being setup."
      end

    when 'abandon'
      puts '***************ABANDON IN PROGRESS GAME***************'
    when 'out'
      puts '***************USER WANTS TO LEAVE***************'
    when 'report'
      puts '***************REPORTING FINISHED GAME***************'
    when 'stats'
      puts '***************GET STATS FOR USER***************'
    when 'help'
      puts '***************PRINT HELP MESSAGE***************'
    else
      puts "***************INVALID (#{command_message}): PRINT HELP MESSAGE***************"
    end

    render json: result
  end

  private

  def user_params
    params.permit(:user_id, :user_name)
  end

  def find_user
    @user = User.where(slack_user_id: user_params[:user_id], slack_user_name: user_params[:user_name]).first_or_create!
  end

  def command_message
    params[:text].gsub("#{params[:trigger_word]} ", '')
  end
end
