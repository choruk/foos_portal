class GamesController < ApplicationController
  def new
  end

  def create
    winners = [User.find(params[:winner_1]), User.find(params[:winner_2])]
    players = winners + [User.find(params[:loser_1]), User.find(params[:loser_2])]

    if players.uniq.size != players.size
      flash[:notice] = 'Players must be unique!'
      return render :new
    end

    game = Game.create!(started_at: Time.zone.now, finished_at: Time.zone.now)

    players.each do |player|
      player.results.create!(game: game, win: winners.include?(player))
    end

    RankingCalculatorService.rank(game)

    flash[:notice] = 'Game successfully created!'

    redirect_to '/'
  end
end
