FactoryBot.define do
  factory :user do
    sequence(:user_name) { |n| "tester#{n}_username" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'foobar' }
  end
end