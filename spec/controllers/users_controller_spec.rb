require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:trip) { create(:trip, user: other_user) }
  let!(:like) { create(:like, user: user, trip: trip) }

  describe 'GET #show' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
        user.follow(other_user)
        get :show, params: { id: user.id }
      end

      example 'レスポンスが正常に表示されること' do
        expect(response).to have_http_status(:success)
      end

      example 'showページが正常に読み込まれること' do
        expect(response).to render_template :show
      end

      example 'インスタンス変数@userが存在する' do
        expect(assigns(:user)).to eq user
      end

      example 'インスタンス変数@followingが存在する' do
        expect(assigns(:following)).to eq user.following
      end

      example 'インスタンス変数@followersが存在する' do
        expect(assigns(:followers)).to eq user.followers
      end

      example 'インスタンス変数@user_likesが存在する' do
        expect(assigns(:user_likes)).to eq user.liked_trips_list
      end
    end
  end

  describe 'GET #index' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
        get :index
      end

      example 'レスポンスが正常に表示されること' do
        expect(response).to have_http_status(:success)
      end

      example 'indexページが正常に読み込まれること' do
        expect(response).to render_template :index
      end
    end

    context 'ログインしていないユーザー' do
      example 'ログインページにリダイレクトされる' do
        get :index
        expect(response).to have_http_status '302'
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
