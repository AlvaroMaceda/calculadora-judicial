require 'rails_helper'
# include My::Matchers

def BANANA(schema)
    expect(response).to have_http_status(:success)
    expect(response).to match_response_schema(schema)
end

RSpec::Matchers.define :be_valid_responde do |schema|
    match do |response|
        have_http_status(:success).matches? response
        match_response_schema("municipality_search").matches? response
    end
    failure_message do |actual_response|
        puts '-----------------'
        puts @banana
        puts '-----------------'
        # "expected that #{actual_monster} would have all the attributes the same as #{expected_monster}. Attributes:\n
        # ACTUAL | EXPECTED\n
        # #{actual_monster.name} | #{expected_monster.name}\n
        # #{actual_monster.skin_color} | #{expected_monster.skin_color}\n
        # #{actual_monster.size} | #{expected_monster.size}\n
        # #{actual_monster.health} | #{expected_monster.health}\n"
    end
end

describe Api::MunicipalityController, type: :controller do

    render_views
    
    describe "GET #search" do

        before(:all) do
            @narnia = create(:autonomous_community, name: 'Narnia')
            @teruel = create(:autonomous_community, name: 'Teruel')
            create(:municipality, name: "Alcala", code: "50001", autonomous_community: @narnia )
            create(:municipality, name: "Calahorra", code: "50002", autonomous_community: @narnia)
            create(:municipality, name: "Calcatta", code: "50003", autonomous_community: @narnia)
            create(:municipality, name: "La Costa Este", code: "80001", autonomous_community: @teruel)
            create(:municipality, name: "Sal calada", code: "80002", autonomous_community: @teruel)
        end

        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end
  
        it 'searches the complete name' do
            get 'search', as: :json, params: { name: 'Calahorra' }

            expect(response).to have_http_status(:success)
            expect(response).to match_response_schema("municipality_search")

            # puts (response.status)
            response.status = 500
            expect(response).to be_valid_responde("municipality_search")

            expected = {municipalities: [
                { code: "50002", name: "Calahorra", ac_id: @narnia.id }
            ]}.to_json
            # expect(response).to include_json(foo)
            expect(response.body).to eq(expected)
        end

        xit 'searches at the midle of the name' do 
            get 'search', as: :json, params: { name: 'atta' }

            expect(response).to have_http_status(:success)
            expect(response).to match_response_schema("municipality_search")
            
            expected = {municipalities: [
                { code: "50003", name: "Calcatta", ac_id: @narnia.id }
            ]}.to_json
            expect(response.body).to eq(expected)
        end

        xit 'it\s not case-sensitive' do
            get 'search', as: :json, params: { name: 'cAL' }

            expect(response).to have_http_status(:success)
            expect(response).to match_response_schema("municipality_search")
            
            puts response.body
            expected =[
                { code: "50003", name: "Calcatta", ac_id: @narnia.id },
                { code: "50001", name: "Alcala", ac_id: @narnia.id },
                { code: "50002", name: "Calahorra", ac_id: @narnia.id },
                { code: "80002", name: "Sal calada", ac_id: @teruel.id },
            ]
            parsed_body = JSON.parse(response.body)
            puts parsed_body['municipalities']
            expect(parsed_body['municipalities']).to match_unordered_json(expected)            
        end

        it 'returns more than one match' do
        end

        it 'works when there are no matches' do
        end

        it 'ignores spaces when searching' do
        end

    end


end