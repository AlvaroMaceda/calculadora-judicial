require 'rails_helper'

describe DeadlineCalculatorResult do

    let(:holiday1) {create(:holiday, date:Date.parse('7 Jul 2015'))}
    let(:holiday2) {create(:holiday, date:Date.parse('8 Aug 2016'))}
    let(:result_holidays) {
        [holiday1, holiday2]
    }

    let(:result_deadline) {Date.parse('21 Jun 2020')}

    let(:result) {
        DeadlineCalculatorResult.new(
            deadline: result_deadline,
            holidays_affected: result_holidays
        )
    }

    it 'has a deadline' do
        expect(result.deadline).to eq(result_deadline)
    end

    it 'has holidays affected' do
        expect(result.holidays_affected).to eq(result_holidays)
    end

    context 'compares with another result' do

        it 'is equal' do
            another_result = DeadlineCalculatorResult.new(
                deadline: result_deadline,
                holidays_affected: result_holidays
            )

            expect(result).to eql(another_result)
        end

        it 'is different if deadline changes' do
            another_result = DeadlineCalculatorResult.new(
                deadline: result_deadline + 1,
                holidays_affected: result_holidays
            )

            expect(result).not_to eql(another_result)            
        end

        it 'is different if holidays changes' do
            another_result = DeadlineCalculatorResult.new(
                deadline: result_deadline,
                holidays_affected: nil
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
