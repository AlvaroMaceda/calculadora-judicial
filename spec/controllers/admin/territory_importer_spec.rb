require 'rails_helper'
include My::Matchers

def example_file(filename)
    File.join(__dir__,'..','..','lib','territory_importer_data',filename)
end

describe Admin::TerritoryImportController, type: :controller do
    
    it 'uploads a csv file' do        
        filename =example_file('correct_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            csv_file: file 
        }
        post :import, params: params

        expected = [
            {kind: :country, code: 'CTES', name: 'Spain', parent: '', population: 0, court: :no},
            {kind: :autonomous_community, code: 'AC01',  name: 'Andalucía', parent: 'CTES', population: 0, court: :no},
            {kind: :island, code: 'ISHIE', name: 'El Hierro', parent: 'AC01', population: 0, court: :no},
            {kind: :region, code: 'REARAN', name: "Val d'Aran", parent: 'ISHIE', population: 0, court: :no},
            {kind: :municipality, code: 'ES26036', name: 'Calahorra', parent: 'REARAN', population: 1234, court: :have},
        ]

        expect(all_territories_in_DB).to match_array(expected)
    end

    it 'redirects to new if all ok' do
        filename =example_file('correct_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            csv_file: file 
        }
        post :import, params: params

        expect(response).to redirect_to(:action => :new)
    end
    
    it 'uploads a csv file containing non-ascii characters' do
        filename = example_file('unicode_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            csv_file: file 
        }
        post :import, params: params
        expected = [
            {kind: :country, code: 'CODE1', name: 'IIƆS∀ ʇou sᴉ sᴉɥ┴', parent: '', population: 0, court: :no},
            {kind: :autonomous_community, code: 'CODE2',  name: 'ʇou IIƆS∀ ʇou sᴉ sᴉɥ┴', parent: 'CODE1', population: 0, court: :no},
        ]

        expect(all_territories_in_DB).to match_array(expected)
    end

    it 'shows an error if csv contains erroneous data' do
        filename = example_file('erroneous_data_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            csv_file: file 
        }
        post :import, params: params

        expect(flash[:error]).to include "Error in csv file"
    end


    it 'shows an error if csv is malformed' do
        filename = example_file('malformed_csv_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            csv_file: file 
        }
        post :import, params: params

        expect(flash[:error]).to include "Error in csv file"
        expect(response).to redirect_to(:admin_import_territories)
    end

end
