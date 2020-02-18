FactoryBot.define do
  factory :schedule do
    date { "2020-02-18 09:11:22" }
    sequence(:place) { |n| "TestPlace#{n}" }
    action { "TestAction" }
    memo { "TestScheduleです。" }
    association :trip
  end
end
