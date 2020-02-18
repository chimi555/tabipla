FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "testrip#{n}" }
    sequence(:content) { "test_tripです" }
    association :user
  end
end
