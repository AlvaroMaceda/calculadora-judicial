FactoryBot.define do
  
  sequence :autonomous_community_code do |n|
    '%02i' % n
  end

  sequence :autonomous_community_name do |n|
    "Autonomous community #{n}"
  end

  factory :autonomous_community do
    code { generate(:autonomous_community_code) }
    name { generate(:autonomous_community_name) }
    country # Equivalent to: association :country, factory: :country

    factory :cuenca do
      name {'Cuenca'}
  
      after(:create) do |ac|
        create_list(:municipality, 10, autonomous_community: ac)
      end
    end

  end
  
end
