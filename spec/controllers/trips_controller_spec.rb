require 'rails_helper'

RSpec.describe TripsController, type: :controller do
  let(:user) { create(:user) }
  let(:trip) { create(:trip) }

  describe 'GET #show' do
    context '全てのユーザー' do
      before do
        get :show, params: { id: trip.id }
      end

      it 'レスポンスが正常に表示されること' do
        expect(response).to have_http_status(:success)
      end

      it 'showページが正常に読み込まれること' do
        expect(response).to render_template :show
      end

      it ' インスタンス変数@userが存在する' do
        expect(assigns(:trip)).to eq trip
      end
    end
  end

  describe 'GET #new' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
        get :new
      end

      it 'レスポンスが正常に表示されること' do
        expect(response).to have_http_status(:success)
      end

      it 'indexページが正常に読み込まれること' do
        expect(response).to render_template :new
      end
    end

    context 'ログインしていないユーザー' do
      it 'ログインページにリダイレクトされる' do
        get :new
        expect(response).to have_http_status '302'
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
