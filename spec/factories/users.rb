FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    sequence(:user_name) { |n| "tester#{n}_username" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    profile { 'Hello!' }
    password { 'foobar' }
    role { :normal }
  end

  trait :guest do
    role { :guest }
    user_name { "テストユーザー" }
    email { "tabipla@example.com" }
    password { "tabipla" }
  end

  trait :admin do
    role { :admin }
    user_name { "管理ユーザー" }
    email { "admin@example.com" }
    password { "admintest" }
  end
end
