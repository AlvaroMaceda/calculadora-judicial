FactoryBot.define do

    factory :holiday do
        for_country # default to the :for_photo trait if none is specified

        trait :for_country do
            association :holidayable, factory: :country
          end

        trait :for_autonomous_community do
          association :holidayable, factory: :autonomous_community
        end
    
        trait :for_municipality do
          association :holidayable, factory: :municipality
        end

      end

  end