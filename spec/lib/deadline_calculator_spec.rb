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
    
    context('no holidays') do

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
            deadline = calculator.from_date(Date.new(2018,10,1),1)
            expect(deadline).to eq(Date.new(2018,10,2)) 
        end
        
        it 'starts counting next workday' do
            a_sunday = Date.new(2018,10,21)
            deadline = calculator.from_date(a_sunday,1)
            expect(deadline).to eq(Date.new(2018,10,22)) 
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
                days = two_working_weeks + 3
                deadline = calculator.from_date(Date.new(2017,6,13),days)
                expect(deadline).to eq(Date.new(2017,6,30)) 
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
                days = a_working_week + 3
                deadline = calculator.from_date(Date.new(2017,6,14),days)
                expect(deadline).to eq(Date.new(2017,6,26)) 
            end

            it 'friday 1 day shift' do
                days = 1
                deadline = calculator.from_date(Date.new(2017,6,9),days)
                expect(deadline).to eq(Date.new(2017,6,12)) 
            end

        end

    end

end
