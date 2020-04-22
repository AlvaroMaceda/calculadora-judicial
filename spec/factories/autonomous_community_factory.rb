

FactoryBot.define do

  # sequence :autonomous_community_code do |n|
  #   "#{'%02i' % n}"
  # end

  sequence :autonomous_community_name do |n|
    "Autonomous Community #{n}"
  end

  factory :autonomous_community do    
    code { Faker::Alphanumeric.unique.alphanumeric(number:2, min_numeric: 2) }
    name { generate(:autonomous_community_name) }

    # name { Faker::Address.unique.community }
    country # Equivalent to: association :country, factory: :country

    factory :cuenca do
      name {'Cuenca'}
  
      after(:create) do |ac|
        create_list(:municipality, 10, autonomous_community: ac)
      end
    end

  end
  
end
