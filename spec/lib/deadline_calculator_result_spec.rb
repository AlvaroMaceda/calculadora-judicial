require 'rails_helper'

describe DeadlineCalculatorResult do
    
    let(:result_deadline) {Date.parse('21 Jun 2020')}

    let(:result_holidays) {
        [
            create(:holiday, date:Date.parse('7 Jul 2015')),
            create(:holiday, date:Date.parse('8 Aug 2016'))
        ]
    }

    let(:missing_holidays) { [create(:territory), create(:territory)] }

    let(:result) {
        DeadlineCalculatorResult.new(
            deadline: result_deadline,
            holidays_affected: result_holidays,
            missing_holidays: missing_holidays
        )
    }

    it 'has a deadline' do
        expect(result.deadline).to eq(result_deadline)
    end

    it 'has holidays affected' do
        expect(result.holidays_affected).to eq(result_holidays)
    end

    it 'has missing holidays' do
        expect(result.missing_holidays).to eq(missing_holidays)
    end

    context 'compares with another result' do

        it 'is equal' do
            another_result = DeadlineCalculatorResult.new(
                deadline: result_deadline,
                holidays_affected: result_holidays,
                missing_holidays: missing_holidays
            )

            expect(result).to eql(another_result)
        end

        it 'is different if deadline changes' do
            another_result = DeadlineCalculatorResult.new(
                deadline: result_deadline + 1,
                holidays_affected: result_holidays,
                missing_holidays: missing_holidays
            )

            expect(result).not_to eql(another_result)            
        end

        it 'is different if holidays changes' do
            another_result = DeadlineCalculatorResult.new(
                deadline: result_deadline,
                holidays_affected: nil,
                missing_holidays: missing_holidays
            )

            expect(result).not_to eql(another_result) 
        end

        it 'is different if missing holidays changes' do
            another_result = DeadlineCalculatorResult.new(
                deadline: result_deadline,
                holidays_affected: result_holidays,
                missing_holidays: [create(:territory)]
            )

            expect(result).not_to eql(another_result) 
        end

    end

    context 'compares with a date' do

        it 'is equal' do
            deadline = result_deadline
            expect(result).to eql(deadline)
        end

        it 'is different' do
            deadline = result_deadline + 1
            expect(result).not_to eql(deadline)
        end

    end

end
