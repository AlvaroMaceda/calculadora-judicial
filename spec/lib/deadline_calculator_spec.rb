require 'rails_helper'
require 'date'

# You can generate calendars with ncalc:
#  export LANG=en_US.utf-8
#  ncal -M -C -d 2018-10
describe DeadlineCalculator do

    it 'instantiates' do
        calculator = DeadlineCalculator.new(create(:country))
        expect(calculator).not_to be nil
    end
    
    context 'no holidays' do

        let(:country_withouth_holidays) {create(:country)}
        let(:calculator) { DeadlineCalculator.new(country_withouth_holidays) }
        let(:a_working_week) { 5*1 }
        let(:two_working_weeks) { 5*2 }
        
        """
        October 2018      
        Mo Tu We Th Fr Sa Su  
         1  2  3  4  5  6  7  
         8  9 10 11 12 13 14  
        15 16 17 18 19 20 21  
        22 23 24 25 26 27 28  
        29 30 31   
        """
        it 'does not count the notification day' do
            notification_date = Date.parse('1 Oct 2018')
            days = 1
            expected_deadline = Date.parse('2 Oct 2018')

            deadline = calculator.deadline(notification_date,days)

            expect(deadline).to eq(expected_deadline)
        end
        
        it 'starts counting next workday' do
            a_sunday = Date.parse('21 Oct 2018')
            days = 1
            expected_deadline = Date.parse('22 Oct 2018')

            deadline = calculator.deadline(a_sunday,days)

            expect(deadline).to eq(expected_deadline)
        end

        context 'extra weekend dont needed' do
            """
                  June 2017        
            Mo Tu We Th Fr Sa Su  
                      1  2  3  4  
             5  6  7  8  9 10 11  
            12 13 14 15 16 17 18  
            19 20 21 22 23 24 25  
            26 27 28 29 30 
            """
            it 'tuesday: 3 days shift' do
                notification_date = Date.parse('13 Jun 2017')
                days = two_working_weeks + 3
                expected_deadline = Date.parse('30 Jun 2017')

                deadline = calculator.deadline(notification_date,days)

                expect(deadline).to eq(expected_deadline)
            end
        end

        context 'extra weekend needed' do

            """
            June 2017        
            Mo Tu We Th Fr Sa Su  
                      1  2  3  4  
             5  6  7  8  9 10 11  
            12 13 14 15 16 17 18  
            19 20 21 22 23 24 25  
            26 27 28 29 30 
            """
            it 'wednesday 3 days shift' do
                notification_date = Date.parse('14 Jun 2017')
                days = a_working_week + 3
                expected_deadline = Date.parse('26 Jun 2017')

                deadline = calculator.deadline(notification_date,days)
                
                expect(deadline).to eq(expected_deadline)
            end

            it 'friday 1 day shift' do
                notification_date = Date.parse('9 Jun 2017')
                days = 1
                expected_deadline = Date.parse('12 Jun 2017')
                
                deadline = calculator.deadline(notification_date,days)
                
                expect(deadline).to eq(expected_deadline)
            end

        end

    end

    xcontext 'holidays' do

        let(:country_withouth_holidays) {create(:country)}
        let(:calculator) { DeadlineCalculator.new(country_withouth_holidays) }
        let(:a_working_week) { 5*1 }
        let(:two_working_weeks) { 5*2 }

        xit 'skips a country\'s holiday' do
        end

        xit 'skips an autonomous community\'s holiday' do
        end

        xit 'skips a municipality\'s holiday' do
        end

        xit 'skips a combination of country, autonomous community and municipality holidays' do
        end

        xit 'does not skip holidays in another municipality' do
        end

        xit 'does not skip holidays in another autonomous community' do
        end

    end

    context 'real examples' do # This will become context('holidays')

        let(:country_with_holidays) {
            country = create(:country, name: 'Country with holidays')
            create(:holiday, :for_country, holidayable: country, date: Date.parse('1 Nov 2019'))
            create(:holiday, :for_country, holidayable: country, date: Date.parse('24 Dec 2019'))
            create(:holiday, :for_country, holidayable: country, date: Date.parse('25 Dec 2019'))
            m = create(:municipality)
            return country
        }

        let(:ac_with_holidays) {
            ac = create(:autonomous_community, country: country_with_holidays, name: 'Autonomous community with holidays')
            create(:holiday, :for_autonomous_community, holidayable: ac, date: Date.parse('6 Dec 2019'))
            return ac
        }

        let(:municipality_with_holidays) {
            municipality = create(:municipality, autonomous_community: ac_with_holidays)
            create(:holiday, :for_municipality, holidayable: municipality, date: Date.parse('9 Sep 2019'))
            return municipality
        }

        let(:calculator) { DeadlineCalculator.new(municipality_with_holidays) }

        """
             May 2017             June 2017             July 2017        
        Mo Tu We Th Fr Sa Su  Mo Tu We Th Fr Sa Su  Mo Tu We Th Fr Sa Su  
        1  2  3  4  5  6  7            1  2  3  4                  1  2  
        8  9 10 11 12 13 14   5  6  7  8  9 10 11   3  4  5  6  7  8  9  
        15 16 17 18 19 20 21  12 13 14 15 16 17 18  10 11 12 13 14 15 16  
        22 23 24 25 26 27 28  19 20 21 22 23 24 25  17 18 19 20 21 22 23  
        29 30 31              26 27 28 29 30        24 25 26 27 28 29 30  
                                                    31                            
        """
        it 'no holidays' do
            notification_date = Date.parse('23 May 2017')
            days = 30
            expected_deadline = Date.parse('4 Jul 2017')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)
        end

        """
           October 2019          November 2019
        Mo Tu We Th Fr Sa Su  Mo Tu We Th Fr Sa Su
            1  2  3  4  5  6              *1* 2  3
         7  8  9 10 11 12 13   4  5  6  7  8  9 10
        14 15 16 17 18 19 20  11 12 13 14 15 16 17
        21 22 23 24 25 26 27  18 19 20 21 22 23 24
        28 29 30 31           25 26 27 28 29 30   
        """
        it 'skips a country\'s holiday'  do
            # Holidays: 1 Nov 2019 (country)
            notification_date = Date.parse('21 Oct 2019')
            days = 20
            expected_deadline = Date.parse('19 Nov 2019')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)            
        end

        """
        November 2019         December 2019          January 2020      
        Mo Tu We Th Fr Sa Su  Mo Tu We Th Fr Sa Su  Mo Tu We Th Fr Sa Su  
                     1  2  3                     1         1  2  3  4  5  
         4  5  6  7  8  9 10   2  3  4  5  6  7  8   6  7  8  9 10 11 12  
        11 12 13 14 15 16 17   9 10 11 12 13 14 15  13 14 15 16 17 18 19  
        18 19 20 21 22 23 24  16 17 18 19 20 21 22  20 21 22 23 24 25 26  
        25 26 27 28 29 30     23 24 25 26 27 28 29  27 28 29 30 31        
                              30 31         
        """
        xit 'skips country and autonomous community holidays' do
            notification_date = Date.parse('26 Nov 2019')
            days = 20
            expected_deadline = Date.parse('3 Jan 2019')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)            
        end

    end

end
