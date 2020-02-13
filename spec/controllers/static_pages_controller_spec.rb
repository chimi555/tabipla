require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #home" do
    it "レスポンスが正常に表示されること" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

end
