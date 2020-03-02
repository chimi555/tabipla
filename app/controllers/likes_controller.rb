class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @trip = Trip.find(params[:trip_id])
    if current_user.already_liked?(@trip)
      redirect_to request.referrer || root_url
    else
      current_user.like(@trip)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end

  def destroy
    @trip = Like.find(params[:id]).trip
    if current_user.already_liked?(@trip)
      current_user.unlike(@trip)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    else
      redirect_to request.referrer || root_url
    end
  end
end
