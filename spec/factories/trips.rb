FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "TestTrip#{n}" }
    sequence(:content) { "test_tripです" }
    association :user
  end
end
