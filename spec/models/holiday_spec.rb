require 'rails_helper'

describe Holiday, type: :model do
  
  it 'has a valid factory' do
      
  end

  context('Country') do

    before(:all) do
      @a_country = create(:country, name: 'Nevermore')
    end

    xit 'can have holidays' do
      christmas = create(:holiday, country: @a_country)
      expect(christmas).to be_valid
    end

    xit 'date must be different' do
    end

  end

end
