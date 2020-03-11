FactoryBot.define do
  factory :trip_tag do
    association :trip
    association :tag
  end
end
