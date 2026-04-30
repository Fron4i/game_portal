FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "#{Faker::Lorem.sentence(word_count: 4)} ##{n}" }
    body { Faker::Lorem.paragraph(sentence_count: 6) }
    kind { :announcement }
    published_at { Time.current }
    association :game
    association :author, factory: :user

    trait :announcement do
      kind { :announcement }
    end

    trait :update do
      kind { :update }
    end

    trait :draft do
      published_at { nil }
    end

    trait :published do
      published_at { Time.current }
    end
  end
end
