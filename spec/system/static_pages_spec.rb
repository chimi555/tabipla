require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  let(:user) { create(:user) }
  let!(:test_user) { create(:user, user_name: "テストユーザー", email:"trilog@example.com", password:"trilog") }
  let!(:trips) { create_list(:trip, 7) }

  describe "topページのレイアウト" do
    context 'ログインしているユーザー' do
      before do
        sign_in_as(user)
        visit root_path
      end

      it "正しいヘッダーが表示されること" do
        within(".header-nav") do
          expect(page).to have_content user.user_name
          expect(page).to have_link "旅行プラン", href: new_trip_path
        end
        within(".header-nav-left") do
          expect(page).to have_link href: users_path
          expect(page).to have_link href: trips_path
        end
      end

      it "新規登録ボタンが表示されないこと" do
        expect(page).not_to have_link "新規登録", href: signup_path
      end

      it "ドロップダウンメニューが正しく表示されること" do
        within(".header-nav") do
          click_on user.user_name
          expect(page).to have_link "マイページ", href: user_path(user.id)
          expect(page).to have_link "ログアウト", href: logout_path
        end
      end

      it "ドロップダウンメニューからマイページへ移動できること" do
        within(".header-nav") do
          click_on user.user_name
          click_on "マイページ"
          expect(page).to have_current_path user_path(user.id)
        end
      end

      it "ドロップダウンメニューからログアウトできること" do
        within(".header-nav") do
          click_on user.user_name
          click_on "ログアウト"
        end
        expect(page).to have_current_path root_path
        expect(page).to have_content 'ログアウトしました。'
      end
    end

    context 'ログインしていないユーザー' do
      before do
        visit root_path
      end

      it "正しいヘッダーが表示されること" do
        expect(page).to have_link "ログイン", href: login_path
        expect(page).to have_button "テストログイン"
        expect(page).to have_link href: trips_path
        expect(page).not_to have_link href: users_path
      end

      it "新規登録ボタンが表示されること" do
        expect(page).to have_link "新規登録", href: signup_path
      end
    end

    context '全てのユーザー' do
      before do
        visit root_path
      end

      it "最新の6件の旅行プランが表示されること" do
        expect(page).to have_link href: trip_path(trips.last.id)
        expect(page).not_to have_link href: trip_path(trips.first.id)
      end

      it "MOREボタンが表示されること" do
        expect(page).to have_link "MORE", href: trips_path
      end
    end
  end

  describe "テストログイン機能" do
    before do
      visit root_path
    end

    it "テストユーザーとしてログインできること" do
      click_on 'テストログイン'
      expect(page).to have_content 'ログインしました。'
      expect(page).to have_current_path user_path(test_user.id)
    end
  end

  describe "検索機能", js: true do
    let!(:search_trip) { create(:trip, name: "温泉旅行", country_code: 'JP') }
    let!(:other_trip) { create(:trip, name: "春の北欧旅行", country_code: 'FI') }

    before do
      visit root_path
    end

    it "キーワードから検索できること" do
      within(".search-form") do
        fill_in "都市名、旅行カテゴリー名(温泉、海外...etc)など", with: '温泉旅行'
        click_on '検索'
      end
      expect(page).to have_content '検索 ：温泉旅行'
      expect(page).to have_link href: trip_path(search_trip.id)
      expect(page).not_to have_link href: trip_path(other_trip.id)
    end

    it "国名から検索できること" do
      within(".search-form") do
        select '日本', from: 'q[country_code_cont]'
        click_on '検索'
      end
      expect(page).to have_content '検索 ：JP'
      expect(page).to have_link href: trip_path(search_trip.id)
      expect(page).not_to have_link href: trip_path(other_trip.id)
    end
  end
end