require 'rails_helper'

RSpec.describe TripsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:trip) { create(:trip, user: user) }

  describe '#index' do
    before do
      get :index
    end

    it 'レスポンスが正常に表示されること' do
      expect(response).to have_http_status(:success)
    end

    it 'showページが正常に読み込まれること' do
      expect(response).to render_template :index
    end
  end

  describe '#show' do
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

      it ' インスタンス変数@tripが存在する' do
        expect(assigns(:trip)).to eq trip
      end
    end
  end

  describe '#new' do
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

  describe '#destroy' do
    context 'ログインしているユーザー' do
      it '自分の旅行プランを削除できる' do
        sign_in user
        expect do
          delete :destroy, params: { id: trip.id }
        end.to change(user.trips, :count).by(-1)
        redirect_to user_path(user)
      end

      it '他人の旅行プランは削除できない' do
        sign_in other_user
        expect do
          delete :destroy, params: { id: trip.id }
        end.not_to change(user.trips, :count)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to root_path
      end
    end

    context 'ログインしていないユーザー' do
      it '旅行プランは削除できない' do
        expect do
          delete :destroy, params: { id: trip.id }
        end.not_to change(user.trips, :count)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
