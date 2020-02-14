# frozen_string_literal: true

User.create!(user_name: 'Example User',
             email: 'example@railstutorial.org',
             password: 'foobar',
             password_confirmation: 'foobar')

99.times do |n|
  user_name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(user_name: user_name,
               email: email,
               password: password,
               password_confirmation: password)
end

users = User.order(:created_at).take(6)
10.times do
  name = Faker::Lorem.sentence(5)
  users.each { |user| user.trips.create!(name: name) }
end
