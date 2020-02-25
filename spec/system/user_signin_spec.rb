require 'rails_helper'

RSpec.describe 'Sign in', type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
  end

  context '入力値が正しいとき' do
    it 'ログインに成功すること', js: true do
      fill_in 'メールアドレスまたはユーザーネーム', with: user.user_name
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(page).to have_current_path user_path(user.id)
      expect(page).to have_content 'ログインしました。'
    end
  end

  context '入力値が正しくないとき' do
    it 'ログインに失敗すること' do
      fill_in 'メールアドレスまたはユーザーネーム', with: user.user_name
      fill_in 'パスワード', with: ''
      click_button 'ログイン'
      expect(page).to have_content 'アカウント情報またはパスワードが違います。'
    end
  end 
end