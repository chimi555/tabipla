class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search
  MAX_OF_DISPLAY_RECENT_TRIPS = 6

  def set_search
    @search = Trip.ransack(params[:q])
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

  # テストユーザーかどうか確認
  def guest_judge
    return unless current_user.guest?
    flash[:info] = '申し訳ありません。テストユーザーは編集できません。'
    redirect_to user_path(current_user.id)
  end

  # 管理者かどうか確認
  def admin_judge
    redirect_to(root_path) unless current_user.admin?
  end
end
