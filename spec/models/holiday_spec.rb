require 'rails_helper'

describe Holiday, type: :model do
  
  it 'has a valid factory' do
    h = create(:holiday)
    expect(h).to be_valid
  end

  context('Country') do

    before(:all) do
      @a_country = create(:country, name: 'Nevermore')
    end

    it 'can have holidays' do
      christmas = create(:holiday, holidayable: @a_country)

      expect(christmas).to be_valid
      expect(christmas.holidayable.class.name).to eq "Country"
    end

    xit 'can\'t have the same date as another holiday in the country' do
    end

    xit 'can have the same date as a holiday in another country' do
    end

    xit 'can have the same date as a holiday in an autonomous community of this country' do
    end

  end

end
