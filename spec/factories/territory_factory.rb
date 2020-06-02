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
    kind { 'municipality' }
    population { rand(1..3000000) }
    court { pick_random(%w[S N])}
  end
  
end