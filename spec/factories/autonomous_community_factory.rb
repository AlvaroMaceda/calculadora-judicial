FactoryBot.define do

  factory :autonomous_community do
    name { Faker::Address.unique.community }
    country # Equivalent to: association :country, factory: :country


    factory :cuenca do
      name {'Cuenca'}
  
      after(:create) do |ac|
        create_list(:municipality, 10, autonomous_community: ac)
      end
    end

  end
  
end
