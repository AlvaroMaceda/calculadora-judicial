require 'rails_helper'
require 'date'

# You can generate calendars with ncalc:
#   export LANG=en_US.utf-8
#   ncal -M -C -d 2018-10
# For two months:
#   paste <(ncal -M -C -d 2018-10) <(ncal -M -C -d 2018-11)
describe DeadlineCalculator do

    it 'instantiates' do
        calculator = DeadlineCalculator.new(create(:territory))
        expect(calculator).not_to be nil
    end
    
    context 'no holidays' do

        let(:territory_withouth_holidays) {create(:territory)}
        let(:calculator) { DeadlineCalculator.new(territory_withouth_holidays) }
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

        """
        October 2018      
        Mo Tu We Th Fr Sa Su  
         1  2  3  4  5  6  7  
         8  9 10 11 12 13 14  
        15 16 17 18 19 20 21  
        22 23 24 25 26 27 28  
        29 30 31 
        """
        it 'starts counting on sunday if notified friday' do
            a_saturday = Date.parse('19 Oct 2018')
            days = 1
            expected_deadline = Date.parse('22 Oct 2018')

            deadline = calculator.deadline(a_saturday,days)

            expect(deadline).to eq(expected_deadline)
        end        

        it 'starts counting on sunday if notified saturday' do
            a_saturday = Date.parse('20 Oct 2018')
            days = 1
            expected_deadline = Date.parse('22 Oct 2018')

            deadline = calculator.deadline(a_saturday,days)

            expect(deadline).to eq(expected_deadline)
        end

        context 'deadline does not end on weekend' do
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
            it 'exact number of weeks' do
                notification_date = Date.parse('23 May 2017')
                days = 30
                expected_deadline = Date.parse('4 Jul 2017')

                deadline = calculator.deadline(notification_date,days)
                
                expect(deadline).to eq(expected_deadline)
            end

        end

        context 'deadline ends on weekend' do

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

    context 'holidays' do 

        before(:each) do
            Spain.create!
        end

        let(:calculator) { DeadlineCalculator.new(Spain.benidorm) }
        
        """
           April 2020       	      May 2020        
        Mo Tu We Th Fr Sa Su  	Mo Tu We Th Fr Sa Su  
               1  2  3  4  5  	             1  2  3  
         6  7  8  9 10 11 12  	 4  5  6  7  8  9 10  
        13 14 15 16 17 18 19  	11 12 13 14 15 16 17  
        20 21 22 23 24 25 26  	18 19 20 21 22 23 24  
        27 28 29 30           	25 26 27 28 29 30 31  
                                                                      
        (see factories/spain.rb for holiday definitions)
        """
        it 'skips a country\'s holiday'  do
            # Holidays: 
            #     1 May (country)
            notification_date = Date.parse('15 Aprl 2020')
            days = 20
            expected_deadline = Date.parse('14 May 2020')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)            
        end

        """
          September 2020     	    October 2020      
        Mo Tu We Th Fr Sa Su  	Mo Tu We Th Fr Sa Su  
            1  2  3  4  5  6  	          1  2  3  4  
         7  8  9 10 11 12 13  	 5  6  7  8  9 10 11  
        14 15 16 17 18 19 20  	12 13 14 15 16 17 18  
        21 22 23 24 25 26 27  	19 20 21 22 23 24 25  
        28 29 30              	26 27 28 29 30 31  
    

        (see factories/spain.rb for holiday definitions)                                
        """
        it 'skips country and autonomous community holidays' do
            # Holidays: 
            #      9 Oct  (autonomous community)
            #     12 Oct (country)
            notification_date = Date.parse('5 Oct 2020')
            days = 10
            expected_deadline = Date.parse('21 Oct 2020')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)            
        end

        """
           November 2020      	   December 2020      
        Mo Tu We Th Fr Sa Su  	Mo Tu We Th Fr Sa Su  
                           1  	    1  2  3  4  5  6  
         2  3  4  5  6  7  8  	 7  8  9 10 11 12 13  
         9 10 11 12 13 14 15  	14 15 16 17 18 19 20  
        16 17 18 19 20 21 22  	21 22 23 24 25 26 27  
        23 24 25 26 27 28 29  	28 29 30 31 
        30     

        (see factories/spain.rb for holiday definitions)   
        """
        it 'skips country, autonomous community and municipality holidays' do
            # Holidays:
            #    10 Dec (municipality)
            #     7 Dec (autonomous community)
            #     8 Dec (country)
            notification_date = Date.parse('25 Nov 2020')
            days = 15
            expected_deadline = Date.parse('21 Dec 2020')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)    
        end

        """
             March 2020       
        lu ma mi ju vi sá do  
                           1  
         2  3  4  5  6  7  8  
         9 10 11 12 13 14 15  
        16 17 18 19 20 21 22  
        23 24 25 26 27 28 29  
        30 31       

        (see factories/spain.rb for holiday definitions)  
        """
        it 'deadline withouth holidays ends in a holiday followed by a working day' do
            # Holidays:
            #     19 March (autonomous community)
            notification_date = Date.parse('16 March 2020')
            days = 3
            expected_deadline = Date.parse('20 March 2020')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)  
        end

        """
             April 2020       
        lu ma mi ju vi sá do  
               1  2  3  4  5  
         6  7  8  9 10 11 12  
        13 14 15 16 17 18 19  
        20 21 22 23 24 25 26  
        27 28 29 30 

        (see factories/spain.rb for holiday definitions)  
        """
        it 'deadline withouth holidays ends in a holiday followed by a weekend' do
            # # Holidays:
            # #     10 Apr (country)
            # #     13 Apr (autonomous community)
            notification_date = Date.parse('6 Apr 2020')
            days = 4
            expected_deadline = Date.parse('14 Apr 2020')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)  
        end

        """
           December 2020      
        Mo Tu We Th Fr Sa Su
            1  2  3  4  5  6  
         7  8  9 10 11 12 13  
        14 15 16 17 18 19 20  
        21 22 23 24 25 26 27  
        28 29 30 31 

        (see factories/spain.rb for holiday definitions)   
        """
        it 'deadline withouth holidays ends in a holiday followed by a holiday' do
            # Holidays:
            #     7 Dec (autonomous community)
            #     8 Dec (country)
            notification_date = Date.parse('1 Dec 2020')
            days = 4
            expected_deadline = Date.parse('9 Dec 2020')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline)  
        end

        """
             August 2020       
        lu ma mi ju vi sá do  
                        1  2  
         3  4  5  6  7  8  9  
        10 11 12 13 14 15 16  
        17 18 19 20 21 22 23  
        24 25 26 27 28 29 30  
        31    

        (see factories/spain.rb for holiday definitions)   
        """
        it 'does not add an additional day if there is a holiday on saturday' do
            # Holidays:
            #     15 Aug (country)
            notification_date = Date.parse('10 Aug 2020')
            days = 5
            expected_deadline = Date.parse('17 Aug 2020')

            deadline = calculator.deadline(notification_date,days)
            
            expect(deadline).to eq(expected_deadline) 
        end

    end

end
