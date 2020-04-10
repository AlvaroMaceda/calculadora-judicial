FactoryBot.define do

  factory :autonomous_community do
    name { Faker::Address.unique.community }
    country # Equivalent to: association :country, factory: :country
  end
  
end
