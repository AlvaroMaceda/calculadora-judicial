FactoryBot.define do
    # factory :country_holiday, class: "Holiday" do
    #   #attributes
    #   holidayable_type "Country"
    # end

    factory :holiday do
        for_country # default to the :for_photo trait if none is specified

        trait :for_country do
            association :holidayable, factory: :country
          end

        trait :for_video do
          association :commentable, factory: :video
        end
    

      end

  end
  
#   FactoryBot.define do
#     factory :ratio_line, class: "Line" do
#       #attributes
#       lineable_type "Ratio"
#     end
#   end