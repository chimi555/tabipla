FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "TestTrip#{n}" }
    sequence(:content) { "test_tripです" }
    country_code { 'FI' }
    area { 'ストックホルム' }
    association :user

    trait :notes do
      notes_attributes do
        [
          { subject: "持ち物", content: "歯ブラシ" },
          { subject: "メンバー", content: "A子、B子" },
        ]
      end
    end
  end
end
