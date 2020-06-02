require 'rails_helper'
include My::Matchers

describe Api::MunicipalitySearchController, type: :controller do
    
    # before { skip }

    render_views
    
    def error_message(response)
        JSON.parse(response.body)['message']
    end
    
    describe "GET #search" do

        def expect_hash(territory)
            return { code: territory.code, name:territory.name }
        end

        before(:each) do
            @alcala = create(:territory, name: 'Alcala', population: 0, court: :no )
            @calahorra = create(:territory, name: 'Calahorra', population: 0, court: :no )
            @calcatta = create(:territory, name: 'Calcatta', population: 0, court: :no )
            @la_costa_este = create(:territory, name: 'La Costa Este', population: 0, court: :no )
            @sal_calada = create(:territory, name: 'Sal Calada', population: 0, court: :no )
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

        it 'only returns municipalities' do
            no_municipality = create(:territory, kind: :country, name: 'Calahorra')

            get 'search', as: :json, params: { name: 'Calahorra' }

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

        it 'returns data ordered by court and then population' do
            municipio_nc2 = create(:territory, name: 'Municipio 4', population: 0, court: :no )
            municipio_nc1 = create(:territory, name: 'Municipio 3', population: 1000, court: :no )
            municipio_c2 = create(:territory, name: 'Municipio 2', population: 0, court: :have )
            municipio_c1 = create(:territory, name: 'Municipio 1', population: 1000, court: :have )
            
            expected = {municipalities: [
                expect_hash(municipio_c1),
                expect_hash(municipio_c2),
                expect_hash(municipio_nc1),
                expect_hash(municipio_nc2)
            ]}.to_json

            get 'search', as: :json, params: { name: 'Municipio' }
            expect(response.body).to eq(expected)
        end

    end # GET #search


end