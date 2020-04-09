FactoryBot.define do

  factory :autonomous_community do
    name { Faker::Address.state }
    country
    # Equivalent to:
    # association :country, factory: :country
  end
  
end
