require 'rails_helper'
include My::Matchers

describe Admin::AutonomousCommunityImportController, type: :controller do


    let(:fileeee) { Rack::Test::UploadedFile.new 'path/to/file.csv', 'text/csv' }
    
    it 'uploads a csv file' do
        filename = 'spec/controllers/admin/autonomous_communities/correct_example_1.csv'
        file = Rack::Test::UploadedFile.new filename, 'text/csv'
    #   CsvParser.should_receive(:parse).with(file)
        params = { upload: file }
        # params = {}
        post :import, params: params
    end

end
