# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #home' do
    let(:user) { FactoryBot.create(:user) }

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
end
