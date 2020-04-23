require 'rails_helper'
include My::Matchers

describe Api::MunicipalityController, type: :controller do

    render_views
    
    describe "GET #search" do

        def expect_hash(municipality)
            return { code: municipality[:code], name:municipality[:name], ac_id: municipality[:autonomous_community].id}
        end
        
        before(:all) do
            @narnia = create(:autonomous_community, name: 'Narnia')
            @teruel = create(:autonomous_community, name: 'Teruel')

            @alcala = {name: "Alcala - search tests", code: "50001", autonomous_community: @narnia }
            @calahorra = {name: "Calahorra - search tests", code: "50002", autonomous_community: @narnia}
            @calcatta = {name: "Calcatta - search tests", code: "50003", autonomous_community: @narnia}
            @la_costa_este = {name: "La Costa Este - search tests", code: "80001", autonomous_community: @teruel}
            @sal_calada = {name: "Sal calada - search tests", code: "80002", autonomous_community: @teruel}
    
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

            # puts @calahorra
            expected = {municipalities: [
                expect_hash(@calahorra)
            ]}.to_json
            # expect(response).to include_json(foo)
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

        it 'ignores spaces when searching' do
            get 'search', as: :json, params: { name: 'lca' }

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

    end


end