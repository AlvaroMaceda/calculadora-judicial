class Spain

    class << self

        def create!

            @country = FactoryBot::create(:country, name: 'Spain') 

            @valencian_community = FactoryBot::create(:autonomous_community, name: 'Comunidad Valenciana', country: @country)
            @basque_country = FactoryBot::create(:autonomous_community, name: 'País Vasco', country: @country)

            @benidorm = FactoryBot::create(:municipality, name: 'Benidorm', autonomous_community: @valencian_community)
            @javea = FactoryBot::create(:municipality, name: 'Javea', autonomous_community: @valencian_community)
                    
            @holidays = {        
                country: {
                    november_1: FactoryBot::create(:holiday, date: Date.parse('1 Nov 2020'), holidayable: @country),
                    december_6: FactoryBot::create(:holiday, date: Date.parse('6 Dec 2020'), holidayable: @country),
                    december_8: FactoryBot::create(:holiday, date: Date.parse('8 Dec 2020'), holidayable: @country),
                    december_25: FactoryBot::create(:holiday, date: Date.parse('25 Dec 2020'), holidayable: @country)    
                },
                valencian_community: {
                    march_19: FactoryBot::create(:holiday, date: Date.parse('19 March 2020'), holidayable: @valencian_community),
                    april_13: FactoryBot::create(:holiday, date: Date.parse('13 Apr 2020'), holidayable: @valencian_community),
                    october_12: FactoryBot::create(:holiday, date: Date.parse('12 Oct 2020'), holidayable: @valencian_community),
                    december_7: FactoryBot::create(:holiday, date: Date.parse('7 Dec 2020'), holidayable: @valencian_community)                    
                },
                basque_country: {
                    march_18: FactoryBot::create(:holiday, date: Date.parse('18 Mar 2020'), holidayable: @basque_country),
                    december_7: FactoryBot::create(:holiday, date: Date.parse('7 Dec 2020'), holidayable: @basque_country)                    
                },
                benidorm: {
                    november_9: FactoryBot::create(:holiday, date: Date.parse('9 Nov 2020'), holidayable: @benidorm),
                    november_10: FactoryBot::create(:holiday, date: Date.parse('10 Nov 2020'), holidayable: @benidorm)
                },
                javea: {
                    november_9: FactoryBot::create(:holiday, date: Date.parse('9 Nov 2020'), holidayable: @javea),
                    november_10: FactoryBot::create(:holiday, date: Date.parse('10 Nov 2020'), holidayable: @javea)
                }                
            }
    
        end

        attr_reader :country
        attr_reader :valencian_community
        attr_reader :benidorm
        attr_reader :holidays
    end
    
end

