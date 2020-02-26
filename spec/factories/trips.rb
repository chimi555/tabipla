FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "TestTrip#{n}" }
    sequence(:content) { "test_tripです" }
    country_code { '日本' }
    area { '愛知県' }
    association :user

    trait :days do
      days_attributes do
        [
          { date: "2020-02-24" },
          { date: "2020-02-25" },
        ]
      end
    end

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
