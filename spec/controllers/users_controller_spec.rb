require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #home" do
    let(:user) {FactoryBot.create(:user)}

    context 'ログイン済ユーザー' do
      it "レスポンスが正常に表示されること" do
        sign_in user
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:success)
      end
    end
  end

end
