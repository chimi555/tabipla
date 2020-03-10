require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:liked_trip) { create(:trip) }
  let(:like) { create(:like, trip: liked_trip, user: user) }

  describe "ユーザー編集ページ" do
    before do
      sign_in_as(user)
      within(".user-info") do
        click_link 'プロフィール編集'
      end
    end

    context 'ページレイアウト' do
      it "正しいプロフィール編集ページが表示されること" do
        expect(page).to have_current_path '/users/edit'
        expect(page).to have_content "ユーザー画像を変更する"
        expect(page).to have_content "ユーザーネーム"
        expect(page).to have_content "自己紹介"
        expect(page).to have_content "メールアドレス"
        expect(page).to have_link "パスワード変更", href: password_edit_user_path(user.id)
      end
    end

    context '一般ユーザー' do
      it "プロフィールの更新に成功すること" do
        fill_in 'ユーザーネーム', with: 'Edit_username'
        fill_in '自己紹介', with: '自己紹介文更新！'
        fill_in 'メールアドレス', with: 'edit@example.com'
        click_button 'プロフィール更新'
        expect(page).to have_current_path user_path(user.id)
        expect(user.reload.user_name).to eq 'Edit_username'
        expect(user.reload.profile).to eq '自己紹介文更新！'
        expect(user.reload.email).to eq 'edit@example.com'
      end

      it "ユーザーアカウントを削除できること", js: true do
        click_on 'アカウント削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_current_path root_path
        expect(page).to have_content "アカウントを削除しました。またのご利用をお待ちしております。"
      end

      it "プロフィールの更新に失敗すること" do
        fill_in 'ユーザーネーム', with: ''
        fill_in '自己紹介', with: '自己紹介文更新！'
        fill_in 'メールアドレス', with: 'edit@example.com'
        click_button 'プロフィール更新'
        # expect(page).to have_current_path '/users/edit'
        expect(page).to have_content 'ユーザーネームが入力されていません。'
        expect(user.reload.profile).not_to eq '自己紹介文更新！'
        expect(user.reload.email).not_to eq 'edit@example.com'
      end
    end
  end

  describe "パスワード変更ページ" do
    before do
      sign_in_as(user)
      within(".user-info") do
        click_link 'プロフィール編集'
      end
      click_link "パスワード変更はこちらから"
    end

    context 'ページレイアウト' do
      it "正しいパスワード変更ページが表示されること" do
        expect(page).to have_current_path password_edit_user_path(user.id)
        expect(page).to have_content "新しいパスワード"
        expect(page).to have_content "新しいパスワード(確認)"
        expect(page).to have_content "現在のパスワード"
      end
    end

    context '有効なユーザー' do
      it "パスワード更新に成功すること" do
        fill_in '新しいパスワード', with: 'newpass'
        fill_in '新しいパスワード(確認)', with: 'newpass'
        fill_in '現在のパスワード', with: 'foobar'
        click_button 'パスワード更新'
        expect(page).to have_current_path user_path(user.id)
        expect(page).to have_content "パスワードを更新しました"
      end

      it "パスワード更新に失敗すること" do
        fill_in '新しいパスワード', with: 'newpass'
        fill_in '新しいパスワード(確認)', with: 'newpass'
        fill_in '現在のパスワード', with: ''
        expect(page).to have_current_path password_edit_user_path(user.id)
        expect(user.reload.password).not_to eq 'newpass'
      end
    end
  end

  describe "ユーザー個別ページ" do
    before do
      sign_in_as(user)
    end

    context '自分のページ' do
      before do
        create_list(:trip, 2, user: user)
        visit user_path(user.id)
      end

      it "プロフィール編集ボタンが表示されること" do
        expect(page).to have_link "プロフィール編集", href: edit_user_registration_path
      end

      it "タブが表示されること" do
        expect(page).to have_content "MyTrip"
        expect(page).to have_content "行きたいリスト"
        expect(page).to have_content "フォロー中"
        expect(page).to have_content "フォロワー"
      end

      it "ホバーするとtripプラン編集・削除ボタンが表示されること", js: true do
        first('.eachtrip-picture').hover
        expect(page).to have_selector '.edit-icon'
        expect(page).to have_selector '.delete-icon'
      end

      it "tripプランが削除できること", js: true do
        first('.eachtrip-picture').hover
        link = find('.delete-icon', match: :first)
        link.click
        page.driver.browser.switch_to.alert.accept
        visit user_path(user.id)
        expect(user.trips.count).to eq 1
      end
    end

    context '他人のページ' do
      before do
        visit user_path(other_user.id)
        create_list(:trip, 2, user: other_user)
      end

      it "プロフィール編集ボタンが表示されないこと" do
        expect(page).not_to have_link "プロフィール編集", href: edit_user_registration_path
      end

      it "tripプラン編集・削除ボタンが表示されないこと" do
        expect(page).not_to have_selector '.edit-icon'
        expect(page).not_to have_selector '.delete-icon'
      end
    end
  end

  describe "タブのテスト", js: true do
    before do
      sign_in_as(user)
    end

    describe "行きたいリスト" do
      context '行きたい登録済の旅行プランがあるとき' do
        before do
          like
          visit user_path(user)
          find('label[for=like_list]').click
        end

        it '行きたい済の旅行プランが表示されること' do
          expect(page).to have_link href: trip_path(liked_trip.id)
        end
      end

      context '行きたい登録済の旅行プランがないとき' do
        before do
          visit user_path(user)
          find('label[for=like_list]').click
        end

        it '行きたい済の旅行プランが一つもないこと' do
          expect(page).to have_content "行きたい！登録済の旅行プランはまだありません"
        end
      end
    end

    describe "フォロー中" do
      context 'フォロー済ユーザーがいるとき' do
        before do
          user.follow(other_user)
          visit user_path(user)
          find('label[for=following_list]').click
        end

        it 'フォロー済のユーザーが表示されること' do
          expect(page).to have_link href: user_path(other_user.id)
        end
      end

      context 'フォロー済ユーザーがいないとき' do
        before do
          visit user_path(user)
          find('label[for=following_list]').click
        end

        it 'フォロー済のユーザーがいないこと' do
          expect(page).to have_content "ユーザーはいません"
        end
      end
    end

    describe "フォロワー" do
      context 'フォローされているユーザーがいるとき' do
        before do
          other_user.follow(user)
          visit user_path(user)
          find('label[for=followers_list]').click
        end

        it 'フォロワーが表示されること' do
          expect(page).to have_link href: user_path(other_user.id)
        end
      end

      context 'フォローされているユーザーがいない' do
        before do
          visit user_path(user)
          find('label[for=followers_list]').click
        end

        it 'フォロワーがいないこと' do
          expect(page).to have_content "ユーザーはいません"
        end
      end
    end
  end
end
