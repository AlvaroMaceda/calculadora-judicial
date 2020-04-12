FactoryBot.define do

  factory :country do
    name { Faker::Address.unique.country }

    factory :spain do
      name {'Spain'}
  
      after(:create) do |country|
        create_list(:autonomous_community, 17, country: country)
      end
    end

  end
  
end
