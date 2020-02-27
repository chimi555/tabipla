FactoryBot.define do
  factory :day do
    date { "2020年02月24日" }
    association :trip
    id { 1 }

    trait :schedules do
      schedules_attributes do
        [
          { time: "10:00", place: "テスト駅", action: "train", memo: "集合です" },
          { time: "12:00", place: "テストレストラン", action: "eat", memo: "昼食です" },
        ]
      end
    end
  end
end
