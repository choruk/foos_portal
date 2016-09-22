class UsersController < ApplicationController
  def index
    @users = User.all.sort { |a, b| a.stale? ? -1 : (b.stale? ? 1 : (a.rank <=> b.rank)) }
                 .reverse.paginate(page: params[:page], per_page: 50)
  end

  def show
    # Hack for usernames with periods in them
    username = params[:format].nil? ? params[:id] : [params[:id], params[:format]].join('.')
    @user = User.where(slack_user_name: username).first
    @stats = StatRetrievalService.find(@user)
  end
end
