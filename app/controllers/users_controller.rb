class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_judge, only: [:password_edit, :password_update]

  def show
    @user = User.find(params[:id])
    @trips = @user.trips.page(params[:page]).per(9)
    @following = @user.following.page(params[:page]).per(9)
    @followers = @user.followers.page(params[:page]).per(9)
    @user_likes = current_user.liked_trips_list.page(params[:page]).per(9)
  end

  def index
    @users = User.all
  end

  def password_edit
  end

  def password_update
    if current_user.update_with_password(password_params)
      sign_in(current_user, bypass: true)
      flash[:success] = "パスワードを更新しました"
      redirect_to current_user
    else
      flash[:danger] = "パスワードが更新できませんでした"
      render "password_edit"
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
