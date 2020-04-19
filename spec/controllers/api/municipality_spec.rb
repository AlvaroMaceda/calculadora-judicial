require 'rails_helper'

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

            puts response.body
            puts @narnia
            expected = {
                municipalities: [
                    {
                        code: "50002",
                        name: "Calahorra",
                        ac_id: @narnia.id
                    }
                ]
            }.to_json
            # expect(response).to include_json(foo)
            expect(response.body).to eq(expected)
        end

        it 'searches at the midle of the name' do
        end

        it 'it\s not case-sensitive' do
        end

        it 'returns more than one match' do
        end

        it 'works when there are no matches' do
        end

        it 'ignores spaces when searching' do
        end

    end


end