FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "TestTrip#{n}" }
    sequence(:content) { "test_tripです" }
    association :user

    trait :schedules do
      schedules_attributes do
        [
          { time: "10:00:00", place: "テスト駅", action: "出発", memo: "集合です" },
          { time: "12:00:00", place: "テストレストラン", action: "食事", memo: "昼食です" },
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
