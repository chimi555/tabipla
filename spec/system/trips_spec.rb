require 'rails_helper'

RSpec.describe 'Trips', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "新規旅行プラン登録ページ" do
    before do
      sign_in user
      visit new_trip_path
    end

    describe "ページレイアウト" do
      it '正しいタイトルが表示されること' do
        expect(page).to have_title full_title('新規旅行プランの登録')
      end

      it '正しいページが表示されること' do
        expect(page).to have_content "旅行プラン登録"
        expect(page).to have_content "旅行メモ"
        expect(page).to have_content "スケジュール"
      end

      context 'タイトルセクション' do
        it '入力フォームが正しく表示されること' do
          within(".trip-picture") do
            expect(page).to have_field("旅行名")
            expect(page).to have_field("サブタイトル")
          end
        end
      end

      context '旅行infoセクション' do
        it '入力フォームが正しく表示されること' do
          within(".trip-info") do
            expect(page).to have_select(selected: '日本')
            expect(page).to have_field("エリア、都市名など")
          end
        end
      end

      context '旅行メモセクション' do
        it '正しいセクション名が表示されること' do
          expect(page).to have_content "旅行メモ"
        end

        it '入力フォームが正しく表示されること' do
          within(".note-form") do
            expect(page).to have_field("タイトル(持ち物、集合場所、メンバー...etc)")
            expect(page).to have_field("内容(パスポート・水着..、駅名...、メンバー名...etc)")
          end
        end

        it 'フォーム追加ボタンが表示されること' do
          within(".note-form") do
            expect(page).to have_css '.each-form-add'
          end
        end
      end

      context 'スケジュールセクション' do
        it '正しいセクション名が表示されること' do
          expect(page).to have_content "スケジュール"
        end

        it '入力フォームが正しく表示されること' do
          within(".schedule-form") do
            expect(page).to have_field("場所名")
            expect(page).to have_field("memo")
          end
        end

        it 'フォーム追加ボタンが表示されること' do
          within(".day-form") do
            expect(page).to have_css '.each-day-add'
          end
          within(".schedule-form") do
            expect(page).to have_css '.each-sche-add'
          end
        end
      end
    end

    describe "新規旅行プラン登録機能", js: true do
      context '正しい入力値' do
        it '新規登録が成功すること' do
          expect do
            within(".trip-picture") do
              fill_in 'trip[name]', with: 'testTrip'
              fill_in 'trip[content]', with: 'これはtestTripです'
            end
            within(".trip-info") do
              select 'フィンランド', from: 'trip[country_code]'
              fill_in 'trip[area]', with: 'ヘルシンキ'
            end
            within(".trip-tag") do
              fill_in 'tag', with: '海外'
            end
            within(".note-form") do
              fill_in 'trip[notes_attributes][0][subject]', with: '持ち物'
              fill_in 'trip[notes_attributes][0][content]', with: 'パスポート'
            end
            within(".day-form") do
              select '2020', from: 'trip[days_attributes][0][date(1i)]'
              select '2月', from: 'trip[days_attributes][0][date(2i)]'
              select '26', from: 'trip[days_attributes][0][date(3i)]'
            end
            within(".schedule-form") do
              select '出発:飛行機', from: 'trip[days_attributes][0][schedules_attributes][0][action]'
              select '10', from: 'trip[days_attributes][0][schedules_attributes][0][time(4i)]'
              select '00', from: 'trip[days_attributes][0][schedules_attributes][0][time(5i)]'
              fill_in 'trip[days_attributes][0][schedules_attributes][0][place]',
                      with: '中部国際空港'
              fill_in 'trip[days_attributes][0][schedules_attributes][0][memo]',
                      with: '集合時間: 8:00'
            end
            click_button '登録'
          end.to change(Trip, :count).by(1)
          expect(page).to have_content '新しい旅行プランが登録されました'
        end
      end

      context '正しくない入力値' do
        it '新規登録が失敗すること' do
          expect do
            within(".trip-picture") do
              fill_in 'trip[name]', with: ''
              fill_in 'trip[content]', with: 'これはtestTripです'
            end
            within(".trip-info") do
              select 'フィンランド', from: 'trip[country_code]'
              fill_in 'trip[area]', with: 'ヘルシンキ'
            end
            within(".schedule-form") do
              select '出発:飛行機', from: 'trip[days_attributes][0][schedules_attributes][0][action]'
              select '10', from: 'trip[days_attributes][0][schedules_attributes][0][time(4i)]'
              select '00', from: 'trip[days_attributes][0][schedules_attributes][0][time(5i)]'
              fill_in 'trip[days_attributes][0][schedules_attributes][0][place]', with: '中部国際空港'
              fill_in 'trip[days_attributes][0][schedules_attributes][0][memo]', with: '集合時間: 8:00'
            end
            click_button '登録'
          end.to change(Trip, :count).by(0)
          expect(page).to have_content '新しい旅行プランの登録に失敗しました'
        end
      end
    end

    describe "フォーム追加・削除機能", js: true do
      context '旅行メモセクション' do
        it 'フォームが追加できること' do
          within(".note-form") do
            expect(page).to have_css '.nested_trip_notes', count: 1
            link = find('.add_nested_fields_link')
            link.click
            expect(page).to have_css '.nested_trip_notes', count: 2
          end
        end

        it 'フォームが削除できること' do
          within(".note-form") do
            add_link = find('.add_nested_fields_link')
            add_link.click
            remove_link = find('.remove_nested_fields_link', match: :first)
            remove_link.click
            expect(page).to have_css '.nested_trip_notes', count: 1
          end
        end
      end

      context 'スケジュールセクション' do
        it 'スケジュールフォームが追加できること' do
          within(".schedule-form") do
            expect(page).to have_css '.nested_trip_days_0_schedules', count: 1
            click_on "スケジュール追加"
            expect(page).to have_css '.nested_trip_days_0_schedules', count: 2
          end
        end

        it 'スケジュールフォームが削除できること' do
          within(".schedule-form") do
            click_on "スケジュール追加"
            remove_link = find('.remove_nested_fields_link', match: :first)
            remove_link.click
            expect(page).to have_css '.nested_trip_days_0_schedules', count: 1
          end
        end

        it '日付フォームが追加できること' do
          within(".day-form") do
            expect(page).to have_css '.nested_trip_days', count: 1
            within(".each-day-add") do
              click_on "日付追加"
            end
            expect(page).to have_css '.nested_trip_days', count: 2
          end
        end

        it '日付フォームが削除できること' do
          within(".day-form") do
            within(".each-day-add") do
              click_on "日付追加"
            end
            within(".each-day-delete", match: :first) do
              remove_link = find('.remove_nested_fields_link', match: :first)
              remove_link.click
            end
            expect(page).to have_css '.nested_trip_days', count: 1
          end
        end
      end
    end
  end

  describe "旅行プラン個別ページ" do
    let(:trip) { create(:trip, :notes, user: user) }
    let!(:day) { create(:day, :schedules, trip: trip) }
    let!(:tag) { create(:tag, tag_name: "北欧") }
    let!(:trip_tag) { create(:trip_tag, trip: trip, tag: tag) }

    describe "ページレイアウト" do
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

      context '旅行infoセクション' do
        it '正しい情報が表示されること' do
          within(".trip-show-info") do
            expect(page).to have_content trip.country_name
            expect(page).to have_content trip.area
          end
        end

        it '正しいタグ名が表示されること' do
          within(".trip-show-tag") do
            expect(page).to have_content tag.tag_name
          end
        end
      end

      context '旅行メモセクション' do
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
      end

      context 'スケジュールセクション' do
        it '正しいセクション名(スケジュール)が表示されること' do
          expect(page).to have_content "スケジュール"
        end

        it '正しい日付が表示されること' do
          within(".trip-show-day") do
            expect(page).to have_content day.date
          end
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

  describe "旅行プラン編集ページ" do
    let!(:trip) { create(:trip, :notes, user: user) }
    let!(:day) { create(:day, :schedules, trip: trip) }

    describe "ページレイアウト" do
      context '正しいユーザー(自分の旅行プラン編集ページにアクセスしたとき)' do
        before do
          sign_in user
          visit edit_trip_path(trip.id)
        end

        it '正しいタイトルが表示されること' do
          expect(page).to have_title full_title("旅行プランの編集")
        end

        it '正しいページが表示されること' do
          expect(page).to have_current_path edit_trip_path(trip.id)
          expect(page).to have_content "旅行プラン編集"
        end

        it 'フォームに正しい情報が入力されていること' do
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

        it 'トップページにリダイレクトされること' do
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
        it '旅行プランの更新に成功すること' do
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

        it "旅行メモが追加できること", js: true do
          within(".note-form") do
            link = find('.add_nested_fields_link')
            link.click
            fill_in 'trip[notes_attributes][2][subject]', with: '集合場所'
            fill_in 'trip[notes_attributes][2][content]', with: '中部国際空港ロビー'
          end
        end

        it "日付とその日のスケジュールが追加できること", js: true do
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
end
