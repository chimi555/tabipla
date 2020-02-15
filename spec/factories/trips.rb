# frozen_string_literal: true

FactoryBot.define do
  factory :trip do
    name { 'MyTrip' }
    association :user
  end
end
