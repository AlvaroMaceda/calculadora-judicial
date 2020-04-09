FactoryBot.define do

  factory :country do
    name { Faker::Address.country }
  end

  factory :country_with_acs do

    after(:build) do |contact|
      
    end

  end
  
end
