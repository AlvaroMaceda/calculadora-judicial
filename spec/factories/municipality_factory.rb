FactoryBot.define do

  sequence :municipality_code do |n|
    to_hex_7_digits n
  end

  factory :municipality do
    code { generate(:municipality_code) }
    name { Faker::Address.city }
    autonomous_community
  end

end