class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @trips = @user.trips
  end

  def index
    @users = User.all
  end

  def password_edit
  end

  def password_update
    if current_user.update_with_password(password_params)
      sign_in(current_user, bypass: true)
      redirect_to current_user, notice: "パスワードを更新しました"
    else
      render "password_edit", alert: "パスワードが更新できませんでした"
    end
  end

  def like
    @user_likes = current_user.liked_trips_list.page(params[:page]).per(10)
  end

  def following
    @title = "フォロー中"
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
