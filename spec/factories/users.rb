FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "johndoe@mail.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_unique_email do
      sequence(:email) { |n| "johndoe#{n}@mail.com" }
    end
  end
end