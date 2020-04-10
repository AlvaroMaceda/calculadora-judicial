FactoryBot.define do

  factory :municipality do
    # code { Faker::}
    # Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)
    name { Faker::Address.municipality }
  end

end