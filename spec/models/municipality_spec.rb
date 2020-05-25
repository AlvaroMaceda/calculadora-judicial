require 'rails_helper'

def PEPE(reponse)
    response.each do |m|
        puts m.name
    end
end

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
            @alcala = create(:municipality, name: 'Alcala' )
            @calahorra = create(:municipality, name: 'Calahorra' )
            @calcatta = create(:municipality, name: 'Calcatta' )
            @la_costa_este = create(:municipality, name: 'La Costa Este' )
            @sal_calada = create(:municipality, name: 'Sal Calada' )
            @rabanos = create(:municipality, name: 'Rábanos')
            @rabanera = create(:municipality, name: 'Rabanera')
            @pollenca = create(:municipality, name: 'Pollença')
            @perales = create(:municipality, name:'Pe-/ra\'les')
        end

        it 'searches the complete name' do
            search_text = 'Calahorra'
            expected = [
                @calahorra
            ]
            
            response = Municipality.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'searches at the midle of the name' do
            search_text = 'atta'
            expected = [
                @calcatta
            ]
            
            response = Municipality.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'it\s not case-sensitive' do
            search_text = 'HoRRa'
            expected = [
                @calahorra
            ]
            
            response = Municipality.similar_to(search_text).to_a

            expect(response).to match_array(expected)         
        end

        it 'works when there are no matches' do
            search_text = 'non existing municipality'
            expected = [
            ]
            
            response = Municipality.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'ignores spaces on database\'s name when searching' do
            search_text = 'lca'
            expected = [
                @alcala,
                @calcatta,
                @sal_calada
            ]
            
            response = Municipality.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'ignores spaces on search string when searching' do
            search_text = 'l ca'
            expected = [
                @alcala,
                @calcatta,
                @sal_calada
            ]
            
            response = Municipality.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'searches ignoring accents' do
            search_text = 'raba'
            expected = [
                @rabanos, @rabanera
            ]

            response = Municipality.similar_to(search_text).to_a
            
            expect(response).to match_array(expected)
        end

        it 'searches ignoring special characters on database' do
            search_text = 'Perales'
            expected = [
                @perales
            ]

            response = Municipality.similar_to(search_text).to_a
            
            expect(response).to match_array(expected)
        end

        it 'searches ignoring special characters on search string' do
            search_text = 'A-lc/a\'la'
            expected = [
                @alcala, @sal_calada
            ]

            response = Municipality.similar_to(search_text).to_a
            
            expect(response).to match_array(expected)
        end

    end

end