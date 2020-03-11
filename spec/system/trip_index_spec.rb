require 'rails_helper'

RSpec.describe 'Trip_index', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:trip) { create(:trip, :notes, user: user) }
  let(:other_trip) { create(:trip) }
  let!(:day) { create(:day, :schedules, trip: trip) }
  let!(:tag) { create(:tag, tag_name: "北欧") }
  let!(:trip_tag) { create(:trip_tag, trip: trip, tag: tag) }

  describe "旅行一覧", js: true do
    context 'カテゴリーが選択されているとき' do
      before do
        sign_in user
        visit trips_path(tag_id: tag.id)
      end

      example '正しいタイトルが表示されること' do
        expect(page).to have_title full_title(tag.tag_name)
      end

      example '正しいカテゴリー名が表示されること' do
        expect(page).to have_content "すべての旅行プラン"
        expect(page).to have_content "カテゴリー：#{tag.tag_name}"
      end

      example "該当カテゴリーに属した旅行プランが表示されること" do
        expect(page).to have_link href: trip_path(trip.id)
      end

      example "該当カテゴリーに属していない旅行プランは表示されないこと" do
        expect(page).not_to have_link href: trip_path(other_trip.id)
      end
    end

    context 'カテゴリーが選択されていないとき' do
      before do
        sign_in user
        visit trips_path
      end

      example '正しいタイトルが表示されること' do
        expect(page).to have_title full_title("旅行プラン一覧")
      end

      example '正しいページ名が表示されること' do
        expect(page).to have_content "すべての旅行プラン"
      end

      example "全ての旅行プランが表示されること" do
        expect(page).to have_link href: trip_path(trip.id)
        expect(page).not_to have_link href: trip_path(other_trip.id)
      end
    end
  end
end
