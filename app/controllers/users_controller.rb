class UsersController < ApplicationController
  def index
    @users = User.order('rank desc').paginate(page: params[:page], per_page: 50)
  end

  def show
    # Hack for usernames with periods in them
    username = params[:format].nil? ? params[:id] : [params[:id], params[:format]].join('.')
    @user = User.where(slack_user_name: username).first
    @stats = StatRetrievalService.find(@user)
  end
end
