require 'rails_helper'
include My::Matchers

describe Admin::AutonomousCommunityImportController, type: :controller do

    let(:country) { create(:country) }

    it 'uploads a csv file' do
        
        filename = 'spec/controllers/admin/autonomous_communities/correct_example_1.csv'
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

end
