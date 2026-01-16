FactoryBot.define do
  factory :notification do
    title { "Ads" }
    content { "Use our Ads resources to revamp your campaign." }
    channel { 0 }
    association :user
  end
end
