FactoryBot.define do
  factory :notification do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    channel { 0 }
    association :user
  end
end
