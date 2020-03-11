require 'rails_helper'

RSpec.describe 'Trip_edit', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:trip) { create(:trip, :notes, user: user) }
  let!(:day) { create(:day, :schedules, trip: trip) }

  describe "ページレイアウト" do
    context '正しいユーザー(自分の旅行プラン編集ページにアクセスしたとき)' do
      before do
        sign_in user
        visit edit_trip_path(trip.id)
      end

      example '正しいタイトルが表示されること' do
        expect(page).to have_title full_title("旅行プランの編集")
      end

      example '正しいページが表示されること' do
        expect(page).to have_current_path edit_trip_path(trip.id)
        expect(page).to have_content "旅行プラン編集"
      end

      example 'フォームに正しい情報が入力されていること' do
        within(".trip-picture") do
          expect(page).to have_field 'trip[name]', with: trip.name
          expect(page).to have_field 'trip[content]', with: trip.content
        end
        within(".trip-info") do
          have_select('trip[country_code]', selected: trip.country_code)
          expect(page).to have_field 'trip[area]', with: trip.area
        end
        within(".note-form") do
          expect(page).to have_field 'trip[notes_attributes][0][subject]', with: trip.notes[0].subject
          expect(page).to have_field 'trip[notes_attributes][0][content]', with: trip.notes[0].content
          expect(page).to have_field 'trip[notes_attributes][1][subject]', with: trip.notes[1].subject
          expect(page).to have_field 'trip[notes_attributes][1][content]', with: trip.notes[1].content
        end
        within(".day-form") do
          have_select('trip[days_attributes][0][date(1i)]', selected: "2020")
          have_select('trip[days_attributes][0][date(2i)]', selected: "2月")
          have_select('trip[days_attributes][0][date(3i)]', selected: "24日")
        end
        within(".schedule-form") do
          have_select('trip[days_attributes][0][schedules_attributes][0][action]',
                      selected: day.schedules[0].action)
          have_select('trip[days_attributes][0][schedules_attributes][0][time(4i)]',
                      selected: "10")
          have_select('trip[days_attributes][0][schedules_attributes][0][time(5i)]',
                      selected: "00")
          expect(page).to have_field 'trip[days_attributes][0][schedules_attributes][0][place]',
                                     with: day.schedules[0].place
          expect(page).to have_field 'trip[days_attributes][0][schedules_attributes][0][memo]',
                                     with: day.schedules[0].memo
          have_select('trip[days_attributes][0][schedules_attributes][1][action]',
                      selected: day.schedules[1].action)
          have_select('trip[days_attributes][0][schedules_attributes][1][time(4i)]',
                      selected: "12")
          have_select('trip[days_attributes][0][schedules_attributes][1][time(5i)]',
                      selected: "00")
          expect(page).to have_field 'trip[days_attributes][0][schedules_attributes][1][place]',
                                     with: day.schedules[1].place
          expect(page).to have_field 'trip[days_attributes][0][schedules_attributes][1][memo]',
                                     with: day.schedules[1].memo
        end
      end
    end

    context '正しくないユーザー(他人の旅行プラン編集ページにアクセスしたとき)' do
      before do
        sign_in other_user
        visit edit_trip_path(trip.id)
      end

      example 'トップページにリダイレクトされること' do
        expect(page).to have_current_path root_path
      end
    end
  end

  describe "旅行プラン編集機能", js: true do
    before do
      sign_in user
      visit edit_trip_path(trip.id)
    end

    context '正しい入力値' do
      example '旅行プランの更新に成功すること' do
        within(".trip-picture") do
          fill_in 'trip[name]', with: 'testTrip編集'
          fill_in 'trip[content]', with: 'これはtestTrip編集です'
        end
        within(".trip-info") do
          select 'ノルウェー', from: 'trip[country_code]'
          fill_in 'trip[area]', with: 'オスロ'
        end
        within(".trip-tag") do
          fill_in 'tag', with: '北欧'
        end
        click_button '更新'
        expect(page).to have_content '旅行情報が更新されました！'
        expect(page).to have_current_path trip_path(trip.id)
        expect(trip.reload.name).to eq 'testTrip編集'
        expect(trip.reload.content).to eq 'これはtestTrip編集です'
        expect(trip.reload.country_code).to eq 'NO'
        expect(trip.reload.area).to eq 'オスロ'
      end

      example "旅行メモが追加できること", js: true do
        within(".note-form") do
          link = find('.add_nested_fields_link')
          link.click
          fill_in 'trip[notes_attributes][2][subject]', with: '集合場所'
          fill_in 'trip[notes_attributes][2][content]', with: '中部国際空港ロビー'
        end
      end

      example "日付とその日のスケジュールが追加できること", js: true do
        within(".each-day-add") do
          click_on "日付追加"
        end
        select '2020', from: 'trip[days_attributes][1][date(1i)]'
        select '2月', from: 'trip[days_attributes][1][date(2i)]'
        select '25', from: 'trip[days_attributes][1][date(3i)]'
        all('.day-form .each-sche-add')[1].click_link 'スケジュール追加'
        select '食事', from: 'trip[days_attributes][1][schedules_attributes][0][action]'
        select '09', from: 'trip[days_attributes][1][schedules_attributes][0][time(4i)]'
        select '00', from: 'trip[days_attributes][1][schedules_attributes][0][time(5i)]'
        fill_in 'trip[days_attributes][1][schedules_attributes][0][place]', with: 'ホテル'
        fill_in 'trip[days_attributes][1][schedules_attributes][0][memo]', with: '朝食'
        click_button '更新'
        expect(page).to have_content '旅行情報が更新されました！'
        expect(page).to have_current_path trip_path(trip.id)
        expect(trip.days.count).to eq 2
        expect(trip.days[1].schedules.count).to eq 1
      end
    end
  end
end
