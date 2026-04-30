FactoryBot.define do
  factory :subscription do
    association :user
    association :game
  end
end
