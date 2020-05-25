
FactoryBot.define do

  sequence :country_code do |n|
    to_hex_two_digits n
  end
  
  sequence :country_name do |n|
    "Country #{n}"
  end
  
  factory :country do
    code { generate(:country_code) }
    name { generate(:country_name) }
  end
  
end
