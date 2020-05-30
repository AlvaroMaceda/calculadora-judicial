FactoryBot.define do

    factory :holiday do
        date { random_date_not_sunday }

        trait :for_country do
            association :holidayable, factory: :country
          end

        trait :for_autonomous_community do
          association :holidayable, factory: :autonomous_community
        end
    
        trait :for_territory do
          association :holidayable, factory: :territory
        end

        trait :for_municipality do
          association :holidayable, factory: :municipality
        end

      end

  end