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

    it "has a unique code" do
        repeated_municipality = build(:municipality, code: municipality.code)
        expect(repeated_municipality).not_to be_valid 
    end

    it "belongs to an autonomous community" do
        expect(municipality.autonomous_community).not_to be nil
    end

    context 'returns its holidays between two dates in order' do

        before(:each) do
            Spain.create!
        end

        it 'includes holidays in the interval' do
            start_date = Date.parse('7 Nov 2020')
            end_date = Date.parse('9 Nov 2020')
            expected = [          
                Spain.holidays[:benidorm][:november_9],
            ]

            holidays_found = Spain.benidorm.holidays_between(start_date, end_date)

            expect(holidays_found).to eq(expected)
        end

        it 'includes autonomous community\'s and country\'s holidays ' do
            start_date = Date.parse('8 Oct 2020')
            end_date = Date.parse('9 Dec 2020')
            expected = [          
                Spain.holidays[:valencian_community][:october_9],
                Spain.holidays[:country][:october_12],
                Spain.holidays[:benidorm][:november_9],                
                Spain.holidays[:benidorm][:november_10],                
                Spain.holidays[:valencian_community][:december_7],      
                Spain.holidays[:country][:december_8],
            ]

            holidays_found = Spain.benidorm.holidays_between(start_date, end_date)

            expect(holidays_found).to eq(expected)
        end
        
    end

    # All scope's tests should be here, not in the controller
    context 'similar_to scope' do

        before(:each) do
            @ac1 = create(:autonomous_community)            
            @ac2 = create(:autonomous_community)

            @alcala_data = {name: "Alcalá", code: "ES50001", autonomous_community: @ac1 }
            @calahorra_data = {name: "Calahorra", code: "ES50002", autonomous_community: @ac1}
            @calcatta_data = {name: "Calcatta", code: "ES50003", autonomous_community: @ac1}
            @la_costa_este_data = {name: "La Costa Este", code: "ES80001", autonomous_community: @ac2}
            @sal_calada_data = {name: "Sal calada Pèmera", code: "ES80002", autonomous_community: @ac2}
            @valencia_de_alcantara_data = {name: "Valencia de Alcántara", code: "ES80003", autonomous_community: @ac2}
    
            @alcala = create(:municipality, @alcala_data )
            @calahorra = create(:municipality, @calahorra_data )
            @calcatta = create(:municipality, @calcatta_data )
            @la_costa_este = create(:municipality, @la_costa_este_data )
            @sal_calada = create(:municipality, @sal_calada_data )
        end

        xit 'searches ignoring accents' do
            search_text = 'cala'
            expected = [
                @alcala, @calahorra, @sal_calada
            ]

            response = Municipality.similar_to(search_text).to_a
            response.each do |m|
                puts m.name
            end
            
            expect(response).to match_array(expected)
        end

    end

end