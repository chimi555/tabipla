class UsersController < ApplicationController
  before_action :authenticate_user! 
  def show
    @user = User.find(params[:id])
    @trip = @user.trips
  end
end
