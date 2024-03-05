FactoryBot.define do
  factory :discount do
    percent_discount { Faker::Number.between(from: 0, to: 50) }
    quantity_threshold { Faker::Number.between(from: 0, to: 40)}
    merchant { association :merchant }
  end
end