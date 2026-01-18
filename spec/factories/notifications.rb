# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    channel { 0 }
    user
  end
end
