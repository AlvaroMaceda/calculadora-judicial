require 'rails_helper'

describe AutonomousCommunity, type: :model do

    let(:ac) { create(:autonomous_community) }

    it "has a valid factory" do
        expect(ac).to be_valid
    end

    it "is invalid without a name" do
        ac = build(:autonomous_community, name: nil)
        expect(ac).not_to be_valid
    end

    it "is invalid with a blank name" do
        ac = build(:autonomous_community, name: '')
        expect(ac).not_to be_valid
    end

    it "is invalid without a code" do
        ac = build(:autonomous_community, code: nil)
        expect(ac).not_to be_valid
    end

    it "belongs to a country" do
        ac.country = nil
        expect(ac).not_to be_valid
    end

    it "has a unique code for a country" do
        repeated_ac = build(:autonomous_community, code: ac.code, country: ac.country)
        expect(repeated_ac).not_to be_valid
    end

    it "can repeat code for another country" do
        another_country = create(:country)
        repeated_ac = build(:autonomous_community, code: ac.code, country: another_country)
        expect(repeated_ac).to be_valid
    end

    it "has multiple municipalities" do
        create_list(:municipality, 10, autonomous_community: ac)
        expect(ac.municipalities.length).to be > 0
    end

    context 'returns its holidays between two dates in order' do

        before(:each) do
            Spain.create!
        end

        it 'includes holidays in the interval' do
            start_date = Date.parse('19 March 2020')
            end_date = Date.parse('13 Apr 2020')
            expected = [          
                Spain.holidays[:valencian_community][:march_19],
                Spain.holidays[:valencian_community][:april_13]
            ]

            holidays_found = Spain.valencian_community.holidays_between(start_date, end_date)

            expect(holidays_found).to eq(expected)
        end

        it 'includes country\'s holidays ' do
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
