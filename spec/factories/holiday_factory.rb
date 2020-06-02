FactoryBot.define do

    factory :holiday do
        date { random_date_not_sunday }
        association :holidayable, factory: :territory
    end

end