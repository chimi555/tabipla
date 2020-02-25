module LoginSupport
  def sign_in_as(user)
    visit login_path
    fill_in 'メールアドレスまたはユーザーネーム', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end