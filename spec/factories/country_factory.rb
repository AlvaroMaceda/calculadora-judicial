FactoryBot.define do

  factory :country do
    # name { "España" }
    name { Faker::Address.country }
  end
  
end
