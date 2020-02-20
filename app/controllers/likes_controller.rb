class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @trip =  Trip.find(params[:trip_id])
    if current_user.already_liked?(@trip)
      redirect_to request.referrer || root_url
    else
      current_user.like(@trip)
      redirect_to request.referrer || root_url
    end
  end

  def destroy
    @trip =  Like.find(params[:id]).trip
    if current_user.already_liked?(@trip)
      current_user.unlike(@trip)
      redirect_to request.referrer || root_url
    else
      redirect_to request.referrer || root_url
    end
  end
end
