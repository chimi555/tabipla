require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  before do
    visit signup_path
  end

  context '有効なユーザー' do
    example '新規登録が成功すること', js: true do
      expect do
        fill_in 'ユーザーネーム', with: 'ExampleUser_username'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'foobar'
        fill_in 'パスワード(確認)', with: 'foobar'
        click_button '新規登録'
      end.to change(User, :count).by(1)
      expect(page).to have_content 'アカウント登録が完了しました。'
    end

    example '新規登録に失敗すること' do
      expect do
        fill_in 'ユーザーネーム', with: ''
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'foobar'
        fill_in 'パスワード(確認)', with: 'foobar'
        click_button '新規登録'
      end.not_to change(User, :count)
      expect(page).to have_content 'ユーザーネームが入力されていません。'
      expect(page).to have_content 'エラーが発生したため ユーザ は保存されませんでした。'
    end
  end
end
