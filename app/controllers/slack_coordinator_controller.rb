class SlackCoordinatorController < ApplicationController
  ALL_COMMANDS = {
    '.foos' => 'Start a new game',
    '.in' => 'Join the current game',
    '.out' => 'Leave the current game',
    '.quit' => 'Abandon the current game',
    '.win' => 'Record a win for the current game',
    '.stats' => 'View personal stats',
    '.rankings' => 'View leaderboard',
    '.help' => 'View this help message'
  }.freeze

  SLACK_TOKEN = ENV['SLACK_TOKEN']

  skip_before_action :verify_authenticity_token, only: :receive

  before_filter :verify_slack_token
  before_filter :find_user

  def receive
    puts params

    json_result = { text: 'Yea I heard you' }
    case command
    when 'foos'
      begin
        game = GameCreationService.create(@user)
        json_result[:text] = "#{@user} is starting a new game. Need #{game.players_needed_to_start} more #{pluralize_players(game.players_needed_to_start)} to start."
      rescue GameCreationService::GameInProgressError, GameCreationService::GameInSetupError => e
        game = e.game
        if game.in_progress?
          json_result[:text] = "Game currently in progress (#{list_players_in_game(game)})."
        else
          json_result[:text] = "A game has already been started. Need #{game.players_needed_to_start} more #{pluralize_players(game.players_needed_to_start)} to start. Type _.in_ to join."
        end
      end

    when 'in'
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
        json_result[:text] = "#{@user} has already joined the game being set up."
      end

    when 'quit'
      success = GameAbandoningService.abandon
      if success
        json_result[:text] = 'Game has been abandoned. Type _.foos_ to start a new one.'
      else
        json_result[:text] = 'There is no game to abandon. Type _.foos_ to start a new one.'
      end

    when 'out'
      begin
        game = GameQuittingService.quit(@user)
        if game
          json_result[:text] = "#{@user} has quit the current game. Need #{game.players_needed_to_start} more #{pluralize_players(game.players_needed_to_start)} to start."
        else
          json_result[:text] = 'All players have quit the game. Type _.foos_ to start a new one.'
        end
      rescue GameQuittingService::UserNotInGameError
        json_result[:text] = "#{@user} is not currently in a game."
      rescue GameQuittingService::GameNotFoundError
        json_result[:text] = 'There is no game to quit. Type _.foos_ to start a new one.'
      rescue GameQuittingService::WinResultFoundError
        json_result[:text] = 'There is already one win recorded. Type _.quit_ to abandon the game. Note: this will cause the current win to be lost.'
      end

    when 'win'
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
      json_result[:text] = StatRetrievalService.stats_string(@user)

    when 'rankings'
      rankings = StatRetrievalService.rankings_string(limit: 15)
      if rankings.present?
        json_result[:text] = rankings
      else
        json_result[:text] = 'There are no ranked players yet.'
      end

    when 'help'
      json_result[:text] = ''
      ALL_COMMANDS.each do |command, description|
        json_result[:text] += "_#{command}_\t\t#{description}\n"
      end

    else
      puts "***************INVALID (#{command}): PRINT HELP MESSAGE***************"
    end

    render json: json_result
  end

  private

  def user_params
    params.permit(:user_id, :user_name)
  end

  def slack_token_param
    params.require(:token)
  end

  def verify_slack_token
    head :unauthorized unless slack_token_param == SLACK_TOKEN
  end

  def find_user
    @user = User.where(slack_user_id: user_params[:user_id]).first_or_create!(slack_user_name: user_params[:user_name])
    #handle people changing their slack username
    @user.update_attributes!(slack_user_name: user_params[:user_name]) if @user.slack_user_name != user_params[:user_name] && user_params[:user_name].present?
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

  def list_players_in_game(game)
    game.players.map(&:slack_user_name).join(', ')
  end
end
