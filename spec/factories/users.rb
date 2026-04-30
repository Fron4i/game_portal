FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@iwebix.test" }
    name { Faker::Name.first_name }
    password { 'password123' }
    password_confirmation { 'password123' }
    confirmed_at { Time.current }
    role { :user }
    blocked { false }

    trait :admin do
      role { :admin }
    end

    trait :blocked do
      blocked { true }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :with_subscriptions do
      transient do
        count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:subscription, evaluator.count, user: user)
      end
    end
  end
end
