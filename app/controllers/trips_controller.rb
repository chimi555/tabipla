class TripsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy, :new]
  before_action :set_trip, only: [:edit, :update, :destroy]
  before_action :set_search, only: [:index]
  before_action :set_available_tags, only: [:edit, :new]

  def index
    if params[:tag_id]
      @selected_tag = Tag.find(params[:tag_id])
      @trips = Trip.from_tag(params[:tag_id]).includes([:user]).page(params[:page]).per(9)
    elsif params[:q]
      @search = Trip.ransack(params[:q])
      @word = params[:q][:name_or_content_or_country_code_or_area_or_tags_tag_name_cont_any]
      @country = params[:q][:country_code_cont]
      @trips = @search.result.includes([:user]).page(params[:page]).per(9)
    else
      @trips = Trip.includes([:user]).page(params[:page]).per(9)
    end
  end

  def show
    @trip = Trip.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
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
    tag_list = params[:tag_list].split(",")
    if @trip.save
      @trip.save_tags(tag_list)
      flash[:success] = '新しい旅行プランが登録されました'
      redirect_to trip_path(@trip.id)
    else
      flash[:danger] = '新しい旅行プランの登録に失敗しました'
      render 'trips/new'
    end
  end

  def edit
    @tag_list = @trip.tags.pluck(:tag_name).join(",")
  end

  def update
    tag_list = params[:tag_list].split(",")
    if @trip.update_attributes(trip_params)
      @trip.save_tags(tag_list)
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

  def set_trip
    @trip = current_user.trips.find(params[:id])
    redirect_to root_url if @trip.nil?
  end

  def set_available_tags
    @all_tag_list = Tag.all.pluck(:tag_name)
  end
end
