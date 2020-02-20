class TripsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy, :new]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @trips = Trip.page(params[:page]).per(10)
  end

  def show
    @trip = Trip.find(params[:id])
  end

  def new
    @trip = current_user.trips.build if user_signed_in?
  end

  def create
    @trip = current_user.trips.build(trip_create_params)
    if @trip.save
      flash[:success] = '新しい旅行プランが登録されました'
      redirect_to trip_path(@trip.id)
    else
      redirect_to root_url
    end
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(trip_update_params)
      flash[:success] = "旅行情報が更新されました！"
      redirect_to @trip
    else
      render 'edit'
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

  def trip_create_params
    params.require(:trip).permit(:name, :content, :picture)
  end

  def trip_update_params
    params.require(:trip).permit(
      :name, :content, :picture,
      schedules_attributes: [:id, :time, :place, :action, :memo, :_destroy],
      notes_attributes: [:id, :subject, :content, :_destroy]
    )
  end

  def correct_user
    @trip = current_user.trips.find_by(id: params[:id])
    redirect_to root_url if @trip.nil?
  end
end
