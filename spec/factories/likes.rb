FactoryBot.define do
  factory :like do
    association :user
    association :trip
  end
end
