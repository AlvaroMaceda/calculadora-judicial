require 'rails_helper'
include My::Matchers

describe Admin::AutonomousCommunityImportController, type: :controller do

    let(:country) { create(:country) }

    it 'uploads a csv file' do        
        filename = File.join(__dir__,'correct_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            country: country.id,
            csv_file: file 
        }
        post :import, params: params

        expected = [
            {code: '01', name: 'Autonomous Community 1', country: country.id},
            {code: '02', name: 'Autonomous Community 2', country: country.id},
            {code: '03', name: 'Autonomous Community 3', country: country.id}
        ]
        expect(all_autonomous_communities_in_DB).to match_array(expected)
    end

    it 'fails if the country does not exists' do
        filename = File.join(__dir__,'correct_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            country: 'unexistent country',
            csv_file: file 
        }
        post :import, params: params

        expect(flash[:error]).to include "Country with id:#{params[:country]} does not exist"
        expect(response).to redirect_to(:admin_import_ac)
    end

    it 'shows an error if csv contains erroneous data' do
        filename = File.join(__dir__,'erroneous_data_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            country: country.id,
            csv_file: file 
        }
        post :import, params: params

        expect(flash[:error]).to include "Error in csv file"
        expect(response).to redirect_to(:admin_import_ac)
    end

    it 'shows an error if csv is malformed' do
        filename = File.join(__dir__,'malformed_csv_example.csv')
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
        
        params = { 
            country: country.id,
            csv_file: file 
        }
        post :import, params: params

        expect(flash[:error]).to include "Error in csv file"
        expect(response).to redirect_to(:admin_import_ac)
    end

end
