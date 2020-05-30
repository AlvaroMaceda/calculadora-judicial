FactoryBot.define do
  
  sequence :territory_code do |n|
    to_hex_7_digits n
  end

  sequence :territory_name do |n|
    "Territory #{n}"
  end

  factory :territory do
    code { generate(:territory_code) }
    name { generate(:territory_name) }
    # country # Equivalent to: association :country, factory: :country
  end
  
end