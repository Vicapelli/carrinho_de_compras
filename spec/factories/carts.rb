FactoryBot.define do
  factory :cart do
    total_price { 0 }
    abandoned_at { nil }

    trait :old do
      updated_at { 4.hours.ago }
    end

    trait :abandoned_long_ago do
      abandoned_at { 8.days.ago }
    end
  end
end
