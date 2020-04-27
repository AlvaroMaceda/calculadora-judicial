require 'rails_helper'

describe Municipality, type: :model do
  
  let(:municipality) { create(:municipality) }

  it "has a valid factory" do
    expect(municipality).to be_valid
  end

  it "is invalid without a name" do
    noname_municipality = build(:municipality, name: nil)
    expect(noname_municipality).not_to be_valid
  end

  it "is invalid without a code" do
    nocode_municipality = build(:municipality, code: nil)
    expect(nocode_municipality).not_to be_valid
  end

  it "has a unique code for its autonomous community " do
    repeated_municipality = build(:municipality, code: municipality.code, autonomous_community: municipality.autonomous_community)
    expect(repeated_municipality).not_to be_valid    
  end

  it "can repeat code for another autonomous community " do
    another_ac = create(:autonomous_community)
    repeated_municipality = create(:municipality, code: municipality.code, autonomous_community: another_ac)
    expect(repeated_municipality).to be_valid    
  end

  it "belongs to an autonomous community" do
    expect(municipality.autonomous_community).not_to be nil
  end

  context 'returns its holidays between two dates in order' do

    before(:each) do
        Spain.create!
    end

    xit 'includes holidays in the interval' do
      start_date = Date.parse('19 March 2020')
      end_date = Date.parse('13 Apr 2020')
      expected = [          
          Spain.holidays[:valencian_community][:march_19],
          Spain.holidays[:valencian_community][:april_13]
      ]

      holidays_found = Spain.benidorm.holidays_between(start_date, end_date)

      expect(holidays_found).to eq(expected)
  end

  xit 'includes autonomous community\'s holidays ' do
  end

  xit 'includes country\'s holidays ' do
      start_date = Date.parse('1 Oct 2020')
      end_date = Date.parse('15 Dec 2020')
      expected = [
          Spain.holidays[:valencian_community][:october_12],
          Spain.holidays[:country][:november_1],
          Spain.holidays[:country][:december_6],
          Spain.holidays[:country][:december_8]
      ]

      holidays_found = Spain.valencian_community.holidays_between(start_date, end_date)

      expect(holidays_found).to eq(expected)
  end

  end

end