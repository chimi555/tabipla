require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:trip) { create(:trip) }
  let(:liked_trip) { create(:trip) }
  let(:like) { create(:like, trip: liked_trip, user: user) }

  describe "行きたい機能" do
    context 'まだ行きたい登録していない旅行プランのページ' do
      before do
        sign_in_as(user)
        visit trip_path(trip.id)
      end

      it '行きたい！ボタンが表示されること' do
        expect(page).to have_button "行きたい！"
      end

      it '行きたい登録でき、行きたい済ボタンに変わること' do
        click_button "行きたい！"
        expect(user.likes.count).to eq 1
        expect(page).to have_button "行きたい済"
      end
    end

    context '既に行きたい登録した旅行プランのページ' do
      before do
        sign_in_as(user)
        like
        visit trip_path(liked_trip.id)
      end

      it '行きたい済ボタンが表示されること' do
        expect(page).to have_button "行きたい済"
      end

      it '行きたい登録解除でき、行きたい！ボタンに変わること' do
        click_button "行きたい済"
        expect(user.likes.count).to eq 0
        expect(page).to have_button "行きたい！"
      end
    end
  end

  describe "行きたいリストページ" do
    context '行きたい登録済の旅行プランがあるとき' do
      before do
        sign_in_as(user)
        like
        visit like_user_path(user)
      end

      it '正しいページにアクセスされること' do
        expect(page).to have_title full_title("行きたいリスト一覧")
        expect(page).to have_content "行きたい！旅行リスト"
      end

      it '行きたい済の旅行プランが表示されること' do
        expect(page).to have_link href: trip_path(liked_trip.id)
      end
    end

    context '行きたい登録済の旅行プランがないとき' do
      before do
        sign_in_as(other_user)
        visit like_user_path(other_user)
      end

      it '正しいページにアクセスされること' do
        expect(page).to have_title full_title("行きたいリスト一覧")
        expect(page).to have_content "行きたい！旅行リスト"
      end

      it '行きたい済の旅行プランが一つもないこと' do
        expect(page).to have_content "まだ行きたい！登録した旅行プランはありません"
      end
    end
  end
end
