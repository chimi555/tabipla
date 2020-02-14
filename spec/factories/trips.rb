FactoryBot.define do
  factory :trip do
    name { "MyTrip" }
    association :user
  end
end
