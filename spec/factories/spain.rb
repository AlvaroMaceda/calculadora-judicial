class Spain

    class << self

        def create!

            @country = FactoryBot::create(:country, name: 'Spain') 
            @valencian_community = FactoryBot::create(:autonomous_community, name: 'Comunidad Valenciana', country: @country)
        
            @holidays = {        
                # Country
                november_1: FactoryBot::create(:holiday, date: Date.parse('1 Nov 2020'), holidayable: @country),
                december_6: FactoryBot::create(:holiday, date: Date.parse('6 Dec 2020'), holidayable: @country),
                december_8: FactoryBot::create(:holiday, date: Date.parse('8 Dec 2020'), holidayable: @country),
                december_25: FactoryBot::create(:holiday, date: Date.parse('25 Dec 2020'), holidayable: @country),
                
                # Autonomous Community
                march_19: FactoryBot::create(:holiday, date: Date.parse('19 March 2020'), holidayable: @valencian_community),
                april_13: FactoryBot::create(:holiday, date: Date.parse('13 Apr 2020'), holidayable: @valencian_community),
                october_12: FactoryBot::create(:holiday, date: Date.parse('12 Oct 2020'), holidayable: @valencian_community)    
            }
    
        end

        attr_reader :country, :valencian_community
        attr_reader :holidays
    end
    
end

