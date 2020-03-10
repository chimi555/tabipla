User.create!(
  user_name: 'テストユーザー',
  email: 'tabipla@example.com',
  password: 'tabipla',
  password_confirmation: 'tabipla',
  role: :guest,
)

User.create!(
  user_name: 'adminユーザー',
  email: Rails.application.credentials.user[:admin_user_email] ,
  password: Rails.application.credentials.user[:admin_user_password],
  password_confirmation: Rails.application.credentials.user[:admin_user_password],
  role: :admin,
)


30.times do |n|
  user_name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(user_name: user_name,
               email: email,
               password: password,
               password_confirmation: password,
               role: :normal)
end