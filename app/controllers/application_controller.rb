class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search

  def set_search
    @search = Trip.ransack(params[:q])
    @search_trips = @search.result.page(params[:page]).per(10)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: %i(user_name email remember_me)
    )
    devise_parameter_sanitizer.permit(
      :account_update, keys: %i(user_name email password image image_cache remove_image profile)
    )
  end
end
