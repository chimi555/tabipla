require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user) }

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

      it "ユーザーアカウントを削除できること" do
        expect do
          click_button 'Cancel my account'
        end.to change(User, :count).by(-1)
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
end
