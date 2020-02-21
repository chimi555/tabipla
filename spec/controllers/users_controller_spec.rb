require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:trip) { create(:trip, user: other_user) }
  let!(:like) { create(:like, user: user, trip: trip) }

  describe 'GET #show' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
        get :show, params: { id: user.id }
      end

      it 'レスポンスが正常に表示されること' do
        expect(response).to have_http_status(:success)
      end

      it 'showページが正常に読み込まれること' do
        expect(response).to render_template :show
      end

      it ' インスタンス変数@userが存在する' do
        expect(assigns(:user)).to eq user
      end
    end
  end

  describe 'GET #index' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
        get :index
      end

      it 'レスポンスが正常に表示されること' do
        expect(response).to have_http_status(:success)
      end

      it 'indexページが正常に読み込まれること' do
        expect(response).to render_template :index
      end
    end

    context 'ログインしていないユーザー' do
      it 'ログインページにリダイレクトされる' do
        get :index
        expect(response).to have_http_status '302'
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#like' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
        get :like, params: { id: user.id }
      end

      it 'レスポンスが正常に表示されること' do
        expect(response).to have_http_status(:success)
      end

      it 'likeページが正常に読み込まれること' do
        expect(response).to render_template :like
      end
    end

    context 'ログインしていないユーザー' do
      it 'ログインページにリダイレクトされる' do
        get :like, params: { id: user.id }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
