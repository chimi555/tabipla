class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_judge, only: [:password_edit, :password_update]
  before_action :admin_judge, only: [:user_destroy]

  def show
    @user = User.find(params[:id])
    @trips = @user.trips.page(params[:page]).per(9)
    @following = @user.following.page(params[:page]).per(9)
    @followers = @user.followers.page(params[:page]).per(9)
    @user_likes = @user.liked_trips_list.page(params[:page]).per(9)
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

  def user_destroy
    if current_user.admin?
      @user = User.find(params[:id])
      @user.destroy
      flash[:success] = "ユーザーの削除に成功しました"
      redirect_to users_path
    else
      flash[:danger] = "他人のアカウントは削除できません"
      redirect_to root_path
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
