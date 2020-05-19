require 'rails_helper'
include My::Matchers

def example_file(filename)
    File.join(__dir__,'..','..','lib','autonomous_community_importer',filename)
end

describe Admin::AutonomousCommunityImportController, type: :controller do

    before(:each) do
        create(:country, code: 'ES')
        create(:country, code: 'GB')
    end

    it 'uploads a csv file' do        
        filename =example_file('correct_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            csv_file: file 
        }
        post :import, params: params

        expected = [
            {code: '01', name: 'Autonomous Community 1', country: 'ES'},
            {code: '02', name: 'Autonomous Community 2', country: 'ES'},
            {code: '01', name: 'Autonomous Community 1', country: 'GB'}
        ]
        expect(all_autonomous_communities_in_DB).to match_array(expected)
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
            {code: '01', name: 'IIƆS∀ ʇou sᴉ sᴉɥ┴', country: 'ES'},
            {code: '02', name: 'ʇou IIƆS∀ ʇou sᴉ sᴉɥ┴', country: 'ES'},
        ]
        expect(all_autonomous_communities_in_DB).to match_array(expected)
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
        expect(response).to redirect_to(:admin_import_ac)
    end

end
