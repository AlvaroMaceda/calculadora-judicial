require 'rails_helper'

describe Api::MunicipalityController, type: :controller do

    before(:all) do
        create(:municipality, name: "Alcala")
        create(:municipality, name: "Calahorra")
        create(:municipality, name: "Calcatta")
        create(:municipality, name: "La Costa Este")
    end

    it 'executes this test' do
        expect(2).to eq 3
    end

    it 'searches the complete name' do
        get :search, params: { name: 'Calahorra' }
        expect(response.content_type).to eq "application/json; charset=utf-8"
        puts response.body
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