class TripsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy, :new]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @trips = Trip.page(params[:page]).per(10)
  end

  def show
    @trip = Trip.find(params[:id])
    respond_to do |f|
      f.html
      f.pdf do
        render pdf: @trip.name,
              encoding: 'UTF-8',
              layout: 'pdf.html',
              template: "trips/show_pdf.html.erb",
              page_size: 'A4',
              dpi: '300'
      end
    end
  end

  def new
    @trip = Trip.new
    @note = @trip.notes.build
    @day = @trip.days.build
    @schedule = @day.schedules.build
  end

  def create
    @trip = current_user.trips.build(trip_params)
    if @trip.save
      flash[:success] = '新しい旅行プランが登録されました'
      redirect_to trip_path(@trip.id)
    else
      flash[:alert] = '新しい旅行プランの登録に失敗しました'
      render 'trips/new'
    end
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(trip_params)
      flash[:success] = "旅行情報が更新されました！"
      redirect_to @trip
    else
      render 'trips/edit'
    end
  end

  def destroy
    if current_user
      @trip.destroy
      flash[:success] = '旅行プランが削除されました'
      redirect_to current_user
    else
      redirect_to root_url
    end
  end

  private

  def trip_params
    params.require(:trip).permit(
      :name, :content, :picture, :picture_cache, :remove_picture, :country_code, :area,
      notes_attributes: [:id, :subject, :content, :_destroy],
      days_attributes: [
        :id, :date, :_destroy,
        schedules_attributes: [:id, :time, :place, :action, :memo, :_destroy],
      ]
    )
  end

  def correct_user
    @trip = current_user.trips.find_by(id: params[:id])
    redirect_to root_url if @trip.nil?
  end
end
