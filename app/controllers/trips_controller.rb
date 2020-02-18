class TripsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :new]
  before_action :correct_user, only: :destroy

  def show
    @trip = Trip.find(params[:id])
  end

  def new
    @trip = current_user.trips.build if user_signed_in?
  end

  def create
    @trip = current_user.trips.build(trip_params)
    if @trip.save
      flash[:success] = '新しい旅行プランが登録されました'
      redirect_to trip_path(@trip.id)
    else
      render 'static_pages/home'
    end
  end

  def destroy
    if current_user
      @trip.destroy
      flash[:success] = 'deleted'
      redirect_to current_user
    else
      redirect_to root_url
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :content, :picture)
  end

  def correct_user
    @trip = current_user.trips.find_by(id: params[:id])
		redirect_to root_url if @trip.nil?
  end
end
