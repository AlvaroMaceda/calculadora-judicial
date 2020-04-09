FactoryBot.define do

  factory :municipality do
    name { Faker::Address.municipality }
  end

end