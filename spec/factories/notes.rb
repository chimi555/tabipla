FactoryBot.define do
  factory :note do
    subject { "持ち物" }

    content { "パスポート" }
    association :trip
  end
end
