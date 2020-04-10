FactoryBot.define do

  factory :autonomous_community do
    name { Faker::Address.unique.state }
    country # Equivalent to: association :country, factory: :country
  end
  
end
