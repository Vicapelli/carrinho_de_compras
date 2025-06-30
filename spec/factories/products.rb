FactoryBot.define do
  factory :product do
    name { FFaker::Name.name }
    price { 10.0 }
  end
end