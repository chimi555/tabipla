FactoryBot.define do
  factory :note do
    subject { "MyString" }
    content { "MyText" }
    trip { nil }
  end
end
