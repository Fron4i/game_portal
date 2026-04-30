FactoryBot.define do
  factory :like do
    association :user

    transient do
      for_post { nil }
      for_comment { nil }
    end

    likeable { for_post || for_comment || association(:post) }
  end
end
