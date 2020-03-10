require 'rails_helper'

RSpec.describe 'Trip_new', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
    visit new_trip_path
  end

  describe "新規旅行プラン登録ページ" do
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
          expect(page).to have_field("旅行名【必須】")
          expect(page).to have_field("サブタイトル")
        end
      end
    end

    context '旅行infoセクション' do
      it '入力フォームが正しく表示されること' do
        within(".trip-info") do
          expect(page).to have_select(selected: '日本')
          expect(page).to have_field("地方名、都道府県名、都市名など")
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
