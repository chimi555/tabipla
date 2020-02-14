# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  before do
    visit signup_path
  end

  context '有効なユーザー' do
    it '新規登録が成功する', js: true do
      expect do
        fill_in 'ユーザーネーム', with: 'ExampleUser_username'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'foobar'
        fill_in '確認用パスワード', with: 'foobar'
        click_button '新規登録'
      end.to change(User, :count).by(1)
      expect(page).to have_content 'アカウント登録が完了しました。'
    end
  end
end
