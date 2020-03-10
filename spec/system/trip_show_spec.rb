require 'rails_helper'

RSpec.describe 'Trip_show', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:trip) { create(:trip, :notes, user: user) }
  let!(:day) { create(:day, :schedules, trip: trip) }
  let!(:tag) { create(:tag, tag_name: "北欧") }
  let!(:trip_tag) { create(:trip_tag, trip: trip, tag: tag) }

  describe "ページレイアウト" do
    context '全てのユーザー' do
      before do
        visit trip_path(trip.id)
      end

      it '正しいタイトルが表示されること' do
        expect(page).to have_title full_title(trip.name)
      end

      it '正しいページが表示されること' do
        expect(page).to have_content trip.name
        expect(page).to have_content trip.content
      end

      it '正しいユーザーinfoが表示されること' do
        within(".trip-show-first") do
          expect(page).to have_content user.user_name
        end
      end

      it '正しい旅行infoが表示されること' do
        within(".trip-show-second") do
          expect(page).to have_content trip.country_name
          expect(page).to have_content trip.area
        end
      end

      it '正しいタグ名が表示されること' do
        within(".trip-show-tag") do
          expect(page).to have_content tag.tag_name
        end
      end

      it '正しいセクション名(旅行メモ)が表示されること' do
        expect(page).to have_content "旅行メモ"
      end

      it '正しい旅行メモが表示されること' do
        within(".trip-show-note") do
          trip.notes.each do |note|
            expect(page).to have_content note.subject
            expect(page).to have_content note.content
          end
        end
      end

      it '正しいセクション名(スケジュール)が表示されること' do
        expect(page).to have_content "スケジュール"
      end

      it '正しいスケジュールが表示されること' do
        within(".trip-show-schedule") do
          day.schedules.each do |schedule|
            expect(page).to have_content schedule.time.strftime("%H:%M")
            expect(page).to have_content schedule.place
            expect(page).to have_content schedule.memo
          end
        end
      end
    end

    context 'ログインユーザー' do
      before do
        sign_in other_user
        visit trip_path(trip.id)
      end

      it 'PDF書き出しリンクが表示されること' do
        expect(page).to have_link "PDFに書き出す", href: trip_path(trip.id, format: :pdf)
      end

      it 'PDFの書き出しができること' do
        click_on "PDFに書き出す"
        expect(page).to have_current_path trip_path(trip.id, format: :pdf)
      end
    end
  end

  describe "編集・削除ボタン" do
    context '自分の旅行ページ' do
      before do
        sign_in user
        visit trip_path(trip.id)
      end

      it "編集・削除ボタンが表示されること" do
        expect(page).to have_link "編集", href: edit_trip_path(trip.id)
        expect(page).to have_link "削除"
      end

      it "編集ページに移動できること" do
        within(".trip-show-btn") do
          click_on "編集"
        end
        expect(page).to have_current_path edit_trip_path(trip.id)
      end

      it "旅行プランが削除できること", js: true do
        within(".trip-show-btn") do
          click_on "削除"
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '旅行プランが削除されました'
        expect(current_path).to eq user_path(user.id)
        expect(user.trips.count).to eq 0
      end
    end

    context '他人の旅行ページ' do
      before do
        sign_in other_user
        visit trip_path(trip.id)
      end

      it "編集・削除ボタンが表示されない" do
        expect(page).not_to have_link "編集", href: edit_trip_path(trip.id)
        expect(page).not_to have_link "削除"
      end
    end
  end
end