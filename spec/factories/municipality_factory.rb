FactoryBot.define do

  factory :municipality do
    code { Faker::Alphanumeric.unique.alphanumeric(number:5, min_numeric: 5) }
    name { Faker::Address.city }
    autonomous_community
  end

end