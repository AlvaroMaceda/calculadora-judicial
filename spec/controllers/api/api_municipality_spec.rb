require 'rails_helper'

describe Api::MunicipalityController, type: :controller do
    describe "GET #search" do

        before(:all) do
            create(:municipality, name: "Alcala", code: "50001")
            create(:municipality, name: "Calahorra", code: "50002")
            create(:municipality, name: "Calcatta", code: "50003")
            create(:municipality, name: "La Costa Este", code: "50004")
        end

        it 'searches the complete name' do
            get :search, params: { name: 'Calahorra' }
            
            puts response.body
            expect(response).to have_http_status(:success)
            expect(response).to match_response_schema("municipality_search") 
        end

        it 'searches at the midle of the name' do
        end

        it 'it\s not case-sensitive' do
        end

        it 'returns more than one match' do
        end

        it 'works when there are no matches' do
        end

    end


end