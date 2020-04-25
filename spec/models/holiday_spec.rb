require 'rails_helper'

describe Holiday, type: :model do
  
  it 'has a valid factory for country' do
    h = create(:holiday, :for_country, date: Date.parse('21 Oct 2015'))
    expect(h).to be_valid
  end

  it 'has a valid factory for autnomous community' do
    h = create(:holiday, :for_autonomous_community, date: Date.parse('21 Oct 2015'))
    expect(h).to be_valid
  end

  it 'has a valid factory for municipality' do
    h = create(:holiday, :for_municipality, date: Date.parse('21 Oct 2015'))
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


  it 'can\'t have the same date as another holiday in the holidayable' do
    date = Date.new(2020,12,25)
    one_country = create(:country)

    christmas = create(:holiday, holidayable:one_country, date: date)
    christmas2 = build(:holiday, holidayable:one_country, date: date)

    expect(christmas2).not_to be_valid
  end

  it 'can have the same date as a holiday in another holidayable' do
    date = Date.new(2020,12,25)
    one_ac = create(:autonomous_community)
    another_ac = create(:autonomous_community)

    christmas = create(:holiday, holidayable: one_ac, date: date)
    christmas2 = build(:holiday, holidayable: another_ac, date: date)

    expect(christmas2).to be_valid
  end

end
