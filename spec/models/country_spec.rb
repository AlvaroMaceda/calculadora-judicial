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

    context 'returns its holidays between two dates in order' do

        # Don't know how to resolve this with let
        before(:each) do
            Spain.create!
        end

        it 'includes holidays in the interval' do
            start_date = Date.parse('30 Oct 2020')
            end_date = Date.parse('15 Dec 2020')
            expected = [
                Spain.holidays[:country][:november_1],
                Spain.holidays[:country][:december_6],
                Spain.holidays[:country][:december_8]
            ]

            holidays_found = Spain.country.holidays_between(start_date, end_date)

            expect(holidays_found).to eq(expected)
        end

        it 'includes start date' do
            start_date = Date.parse('1 Nov 2020')
            end_date = Date.parse('15 Dec 2020')
            expected = [
                Spain.holidays[:country][:november_1],
                Spain.holidays[:country][:december_6],
                Spain.holidays[:country][:december_8]
            ]

            holidays_found = Spain.country.holidays_between(start_date, end_date)

            expect(holidays_found).to eq(expected)
        end

        it 'includes end date' do 
            start_date = Date.parse('30 Oct 2020')
            end_date = Date.parse('25 Dec 2020')
            expected = [
                Spain.holidays[:country][:november_1],
                Spain.holidays[:country][:december_6],
                Spain.holidays[:country][:december_8],
                Spain.holidays[:country][:december_25]
            ]

            holidays_found = Spain.country.holidays_between(start_date, end_date)

            expect(holidays_found).to eq(expected)
        end

    end

end
