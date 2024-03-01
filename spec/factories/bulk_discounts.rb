FactoryBot.define do
  factory :bulk_discount do
    percentage_discount { 1 }
    quantity_treshold { 1 }
    merchant_id { nil }
  end
end
