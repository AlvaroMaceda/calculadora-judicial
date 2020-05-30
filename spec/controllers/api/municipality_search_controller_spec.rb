require 'rails_helper'
include My::Matchers

describe Api::MunicipalitySearchController, type: :controller do
    
    before { skip }

    render_views
    
    def error_message(response)
        JSON.parse(response.body)['message']
    end
    
    describe "GET #search" do

        def expect_hash(territory)
            return { code: territory.code, name:territory.name }
        end

        before(:each) do
            @alcala = create(:territory, name: 'Alcala' )
            @calahorra = create(:territory, name: 'Calahorra' )
            @calcatta = create(:territory, name: 'Calcatta' )
            @la_costa_este = create(:territory, name: 'La Costa Este' )
            @sal_calada = create(:territory, name: 'Sal Calada' )
        end

        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end
  
        it 'searches similar municipalities using Municipality similar_to scope' do
            get 'search', as: :json, params: { name: 'lca' }

            expect(response).to be_json_success_response("municipality_search")

            expected = {municipalities: [
                expect_hash(@alcala),
                expect_hash(@calcatta),
                expect_hash(@sal_calada)
            ]}.to_json
            expect(response.body).to eq(expected)  
        end

        it 'works when there are no matches' do
            get 'search', as: :json, params: { name: 'non existing municipality' }

            expect(response).to be_json_success_response("municipality_search")

            expected = {municipalities: []}.to_json
            expect(response.body).to eq(expected) 
        end

        it 'returns an empty array if search string is empty' do
            get 'search', as: :json, params: { name: '' }

            expect(response).to be_json_success_response("municipality_search")

            expected = {municipalities: []}.to_json
            expect(response.body).to eq(expected)              
        end

        it 'returns error if there are less than three characters' do
            get 'search', as: :json, params: { name: 'po' }

            expect(response).to be_json_error_response
            expect(error_message(response)).to include "Too few characters to search"
        end

    end


end