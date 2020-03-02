FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    sequence(:user_name) { |n| "tester#{n}_username" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    profile { 'Hello!' }
    password { 'foobar' }
  end
end
