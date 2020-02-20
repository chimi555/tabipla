require 'rails_helper'

RSpec.describe 'Trips', type: :system do
  let(:user) { create(:user) }

  describe "新規旅行プラン登録" do
    before do
      sign_in user
      visit new_trip_path
    end

    context '有効なユーザー' do
      it '新規登録が成功する' do
        expect do
          fill_in '旅行名', with: 'testTrip'
          fill_in '旅行概要', with: 'これはtestTripです'
          click_button '登録'
        end.to change(Trip, :count).by(1)
        expect(page).to have_content '新しい旅行プランが登録されました'
      end
    end
  end
end
