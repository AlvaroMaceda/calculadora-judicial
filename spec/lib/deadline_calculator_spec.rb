require 'rails_helper'
require 'date'

describe DeadlineCalculator do

    let(:country_withouth_holidays) {create(:country)}
    

    it 'instantiates' do
        calculator = DeadlineCalculator.new(country_withouth_holidays)
        expect(calculator).not_to be nil
    end
    
    context('no holidays') do

        let(:calculator) { DeadlineCalculator.new(country_withouth_holidays) }
        let(:two_working_weeks) { 5*2 }
        
        it 'does not count the notification day' do
            deadline = calculator.from_date(Date.new(2018,10,1),1)
            expect(deadline).to eq(Date.new(2018,10,2)) 
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
                days = two_working_weeks + 2
                deadline = calculator.from_date(Date.new(2017,6,13),days)
                expect(deadline).to eq(Date.new(2017,6,29)) 
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
            xit 'wednesday 3 days shift' do

            end

            xit 'friday 1 day shift' do

            end

        end

    end

end
