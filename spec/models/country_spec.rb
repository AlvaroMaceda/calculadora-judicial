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
        before(:all) do
            # @country = create(:country) 
            # @november_1 = create(:holiday, date: Date.parse('1 Nov 2020'), holidayable: @country)
            # @december_6 = create(:holiday, date: Date.parse('6 Dec 2020'), holidayable: @country)
            # @december_8 = create(:holiday, date: Date.parse('8 Dec 2020'), holidayable: @country)
            # @december_25 = create(:holiday, date: Date.parse('25 Dec 2020'), holidayable: @country)
        end

        let (:spain_country) { Spain.country }

        it 'includes holidays in the interval' do
            # puts '-----------------------'
            # puts Spain.holidays.class.name
            # puts '-----------------------'
            # puts 'Banana'
            # puts '***'+Spain.holidays[:november_1]+'***'
            # puts '-----------------------'
            start_date = Date.parse('30 Oct 2020')
            end_date = Date.parse('15 Dec 2020')
            expected = [
                Spain.holidays[:november_1],
                Spain.holidays[:december_6],
                Spain.holidays[:december_8]
            ]

            holidays_found = spain_country.holidays_between(start_date, end_date)

            puts '-----------------------'
            puts 'Holidays found:'
            puts holidays_found.count
            puts '-----------------------'

            expect(holidays_found).to eq(expected)
        end

        xit 'includes start date' do
            start_date = Date.parse('1 Nov 2020')
            end_date = Date.parse('15 Dec 2020')
            expected = [
                spain.holidays[:november_1],
                spain.holidays[:december_6],
                spain.holidays[:december_8]
            ]

            holidays_found = @country.holidays_between(start_date, end_date)

            expect(holidays_found).to eq(expected)
        end

        xit 'includes end date' do 
            start_date = Date.parse('30 Oct 2020')
            end_date = Date.parse('25 Dec 2020')
            expected = [
                @november_1,
                @december_6,
                @december_8,
                @december_25,
            ]

            holidays_found = @country.holidays_between(start_date, end_date)

            expect(holidays_found).to eq(expected)
        end

    end

end
