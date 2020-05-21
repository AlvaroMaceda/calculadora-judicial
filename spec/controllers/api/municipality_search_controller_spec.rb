require 'rails_helper'
include My::Matchers

describe Api::MunicipalitySearchController, type: :controller do

    render_views
    
    def error_message(response)
        JSON.parse(response.body)['message']
    end
    
    describe "GET #search" do

        def expect_hash(municipality)
            return { code: municipality[:code], name:municipality[:name] }
        end

        
        before(:each) do
            @ac1 = create(:autonomous_community)            
            @ac2 = create(:autonomous_community)

            @alcala = {name: "Alcala - search tests", code: "ES50001", autonomous_community: @ac1 }
            @calahorra = {name: "Calahorra - search tests", code: "ES50002", autonomous_community: @ac1}
            @calcatta = {name: "Calcatta - search tests", code: "ES50003", autonomous_community: @ac1}
            @la_costa_este = {name: "La Costa Este - search tests", code: "ES80001", autonomous_community: @ac2}
            @sal_calada = {name: "Sal calada - search tests", code: "ES80002", autonomous_community: @ac2}
            @valencia_de_alcantara = {name: "Valencia de Alcántara", code: "ES80003", autonomous_community: @ac2}
    
            create(:municipality, @alcala )
            create(:municipality, @calahorra )
            create(:municipality, @calcatta )
            create(:municipality, @la_costa_este )
            create(:municipality, @sal_calada )
        end

        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end
  
        it 'searches the complete name' do
            get 'search', as: :json, params: { name: 'Calahorra' }

            expect(response).to be_json_success_response("municipality_search")

            expected = {municipalities: [
                expect_hash(@calahorra)
            ]}.to_json
            expect(response.body).to eq(expected)
        end

        it 'searches at the midle of the name' do 
            get 'search', as: :json, params: { name: 'atta' }

            expect(response).to be_json_success_response("municipality_search")
            
            expected = {municipalities: [
                expect_hash(@calcatta)
            ]}.to_json
            expect(response.body).to eq(expected)
        end

        it 'it\s not case-sensitive' do
            get 'search', as: :json, params: { name: 'HoRRa' }

            expect(response).to be_json_success_response("municipality_search")
            
            expected = {municipalities: [
                expect_hash(@calahorra)
            ]}.to_json
            expect(response.body).to eq(expected)            
        end

        it 'works when there are no matches' do
            get 'search', as: :json, params: { name: 'non existing municipality' }

            expect(response).to be_json_success_response("municipality_search")

            expected = {municipalities: []}.to_json
            expect(response.body).to eq(expected) 
        end

        it 'ignores spaces on database\'s name when searching' do
            get 'search', as: :json, params: { name: 'lca' }

            expect(response).to be_json_success_response("municipality_search")

            expected = {municipalities: [
                expect_hash(@alcala),
                expect_hash(@calcatta),
                expect_hash(@sal_calada)
            ]}.to_json
            expect(response.body).to eq(expected)  
        end

        it 'ignores spaces on search string when searching' do
            get 'search', as: :json, params: { name: 'l ca' }

            expect(response).to be_json_success_response("municipality_search")

            expected = {municipalities: [
                expect_hash(@alcala),
                expect_hash(@calcatta),
                expect_hash(@sal_calada)
            ]}.to_json
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