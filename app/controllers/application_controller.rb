# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

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
