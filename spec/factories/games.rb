FactoryBot.define do
  factory :game do
    sequence(:title) { |n| "#{Faker::Game.title} ##{n}" }
    description { Faker::Lorem.paragraph(sentence_count: 4) }
    released_at { 1.month.ago }

    trait :with_cover do
      after(:build) do |game|
        game.cover.attach(
          io: Rails.root.join('spec/fixtures/files/cover.png').open,
          filename: 'cover.png',
          content_type: 'image/png'
        )
      end
    end
  end
end
