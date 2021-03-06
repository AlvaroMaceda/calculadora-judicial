require 'rails_helper'

describe Holiday, type: :model do

    it 'has a valid factory for territory' do
        h = create(:holiday, date: Date.parse('21 Oct 2015'))
        expect(h).to be_valid
    end

    it 'must have a date' do
        holiday = build(:holiday, date: nil)
        expect(holiday).not_to be_valid
    end

    it 'does not admit an invalid date' do
        holiday = build(:holiday, date: 'banana')
        expect(holiday).not_to be_valid
    end

    """
        January 2020      
    Mo Tu We Th Fr Sa Su  
           1  2  3  4  5  
     6  7  8  9 10 11 12  
    13 14 15 16 17 18 19  
    20 21 22 23 24 25 26  
    27 28 29 30 31 
    """
    it 'Can\'t be sunday' do
        holiday = build(:holiday, date: Date.parse('12 Jan 2020'))
        expect(holiday).not_to be_valid
    end

    it 'can\'t have the same date as another holiday in the holidayable' do
        date = Date.new(2020,12,25)
        one_territory = create(:territory)

        christmas = create(:holiday, holidayable:one_territory, date: date)
        christmas2 = build(:holiday, holidayable:one_territory, date: date)

        expect(christmas2).not_to be_valid
    end

    it 'can have the same date as a holiday in another holidayable' do
        date = Date.new(2020,12,25)
        one_territory = create(:territory)
        another_territory = create(:territory)

        christmas = create(:holiday, holidayable: one_territory, date: date)
        christmas2 = build(:holiday, holidayable: another_territory, date: date)

        expect(christmas2).to be_valid
    end

end
