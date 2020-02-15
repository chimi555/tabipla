class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @trips = @user.trips
  end

  def index
    @users = User.all
  end
end
