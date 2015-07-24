class SlackCoordinatorController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :receive

  before_filter :find_user

  # This will be the action that gets hit by slack when
  # someone uses the trigger word in the right channel.
  def receive
    puts params

    json_result = { text: 'Yea I heard you' }
    case command
    when 'foos'
      puts '***************STARTING GAME***************'
      begin
        game = GameCreationService.create(@user)
        json_result[:text] = "#{@user} is starting a new game. Need #{game.players_needed_to_start} more #{pluralize_players(game.players_needed_to_start)} to start."
      rescue GameCreationService::GameInProgressError, GameCreationService::GameInSetupError => e
        game = e.game
        if game.in_progress?
          json_result[:text] = 'Game currently in progress.'
        else
          json_result[:text] = "Need #{game.players_needed_to_start} more #{pluralize_players(game.players_needed_to_start)} to start. Type .in to join."
        end
      end
    when 'in'
      puts '***************USER WANTS TO JOIN***************'
      begin
        game = GameJoiningService.join(@user)
        if game
          if game.in_progress?
            json_result[:text] = "#{@user} has joined the game.\nTTT"
          else
            json_result[:text] = "#{@user} has successfully joined the game. Need #{game.players_needed_to_start} more #{pluralize_players(game.players_needed_to_start)} to start."
          end
        else
          json_result[:text] = 'No game could be joined.'
        end
      rescue GameJoiningService::UserAlreadyJoinedError
        json_result[:text] = "#{@user} has already joined the game being setup."
      end

    when 'quit'
      puts '***************ABANDON IN PROGRESS GAME***************'
      success = GameAbandoningService.abandon
      if success
        json_result[:text] = 'Game has been abandoned. Type .foos to start a new one.'
      else
        json_result[:text] = 'There is no game to abandon. Type .foos to start a new one.'
      end
    when 'out'
      puts '***************USER WANTS TO LEAVE***************'
      begin
        game = GameQuittingService.quit(@user)
        if game
          json_result[:text] = "#{@user} has quit the current game. Need #{game.players_needed_to_start} more #{pluralize_players(game.players_needed_to_start)} to start."
        else
          json_result[:text] = 'All players have quit the game. Type .foos to start a new one.'
        end
      rescue GameQuittingService::UserNotInGameError
        json_result[:text] = "#{@user} is not currently in a game."
      rescue GameQuittingService::GameNotFoundError
        json_result[:text] = 'There is no game to quit. Type .foos to start a new one.'
      end
    when 'win'
      puts '***************REPORTING FINISHED GAME***************'
      begin
        result = ResultCreationService.create(@user)
        game = result.game
        if game.finished?
          json_result[:text] = "Recorded win for #{@user}. All wins reported."
        else
          json_result[:text] = "Recorded win for #{@user}. Need #{game.players_needed_to_finish} more #{pluralize_players(game.players_needed_to_finish)} to report a win."
        end
      rescue ResultCreationService::NoGameInProgressError
        json_result[:text] = 'Cannot record win because there is no game in progress.'
      rescue ResultCreationService::ResultAlreadyRecordedError
        json_result[:text] = "#{@user} has already recorded a win for this game."
      end
    when 'stats'
      puts '***************GET STATS FOR USER***************'
    when 'help'
      puts '***************PRINT HELP MESSAGE***************'
    else
      puts "***************INVALID (#{command_message}): PRINT HELP MESSAGE***************"
    end

    render json: json_result
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

  def command
    params[:trigger_word].sub('.', '')
  end

  def pluralize_players(count)
    'player'.pluralize(count)
  end
end
