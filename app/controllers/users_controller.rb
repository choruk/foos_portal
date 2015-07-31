class UsersController < ApplicationController
  def index
    @users = User.order(:slack_user_name).paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.where(slack_user_name: params[:id]).first
  end
end
