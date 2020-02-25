FactoryBot.define do
  factory :day do
    date { "2020-02-24" }
    association :trip

    trait :schedules do
      schedules_attributes do
        [
          { time: "10:00:00", place: "テスト駅", action: "出発", memo: "集合です" },
          { time: "12:00:00", place: "テストレストラン", action: "食事", memo: "昼食です" },
        ]
      end
    end
  end
end
