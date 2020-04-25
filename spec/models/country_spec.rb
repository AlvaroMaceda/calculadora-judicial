require 'rails_helper'

describe Country, type: :model do

    let(:country) { create(:country) }

    it 'has a valid factory' do
        # country = create(:country)
        expect(country).to be_valid
    end

    it 'is invalid without a name' do
        country = build(:country, name: nil)
        expect(country).not_to be_valid
    end

    it 'has multiple autonomous communities' do
        # spain = create(:spain)
        create_list(:autonomous_community, 17, country: country)
        expect(country.autonomous_communities.length).to be > 0
    end

    it 'returns its holidays between two dates in order' do        
        h1 = create(:holiday, date: Date.parse('6 Dec 2020'), holidayable: country)
        h2 = create(:holiday, date: Date.parse('8 Dec 2020'), holidayable: country)
        h3 = create(:holiday, date: Date.parse('25 Dec 2020'), holidayable: country)
        
        holidays = country.holidays_between(Date.parse(), Date.parse())

        expect(holidays).to eq([h2, h3])
    end

end
