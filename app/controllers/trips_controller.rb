class TripsController < ApplicationController
  def create
    @trip = current_user.trips.build(trip_params)
    if @trip.save
      flash[:success] = '新しい旅行プランが登録されました'
      redirect_to trip_path(@trip.id)
    else
      render 'static_pages/home'
    end
  end

  def new
    @trip = current_user.trips.build if user_signed_in?
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :content)
  end
end
