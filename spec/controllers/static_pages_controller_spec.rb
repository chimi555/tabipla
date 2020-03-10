require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    let!(:trip_recent) { create_list(:trip, 7) }
    
    before do
      get :home
    end

    it 'レスポンスが正常に表示されること' do
      expect(response).to have_http_status(:success)
    end

    it 'インスタンス変数@trip_recentには最新の6件の旅行プランが格納されること' do
      expect(assigns(:trip_recent).count).to eq 6
    end
  end
end
