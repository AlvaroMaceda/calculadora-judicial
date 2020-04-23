require 'rails_helper'
require 'date'

describe WorkingDaysCalculator do

    let(:country_withouth_holidays) {create(:country)}
    

    it 'instantiates' do
        calculator = WorkingDaysCalculator.new(country_withouth_holidays)
        expect(calculator).not_to be nil
    end
    
    context('no holidays') do

        let(:calculator) { WorkingDaysCalculator.new(country_withouth_holidays) }
        
        context 'excludes saturdays and sundays' do
            
            it 'starts in workday' do                
                # 1 Oct 2018 is monday
                deadline = calculator.deadline(Date.new(2018,10,1),7)
                expect(deadline).to eq(Date.new(2018,10,10))
            end
        
            xit 'starts in weekend' do  
                # 3 March 2018 is saturday             
                wd = calculator.deadline(Date.new(2018,3,3),1)
                expect(wd).to eq(5)
            end

            xit 'more than a week' do
                wd = calculator.deadline(Date.new(2018,10,1),7)
                expect(wd).to eq(5)
            end

            
        end

    end

end
