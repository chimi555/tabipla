FactoryBot.define do
  factory :schedule do
    time { "09:11:22" }
    sequence(:place) { |n| "TestPlace#{n}" }
    action { "TestAction" }
    memo { "TestScheduleです。" }
    association :day
  end
end
