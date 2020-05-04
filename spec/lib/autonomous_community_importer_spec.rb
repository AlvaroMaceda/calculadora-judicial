require 'rails_helper'

CSV_PATH = File.join(__dir__,'csv','autonomous_communities')
def csv_example(file_name)
    File.open( File.join(CSV_PATH,file_name+'.csv') , "r")
end

describe DeadlineCalculator do

    let(:importer) { AutonomousCommunityImporter.new(create(:country)) }

    it 'class exists' do
        expect { AutonomousCommunityImporter }.not_to raise_error
    end

    it 'imports autonomous communities' do
        
        
        # This does not work
        csv_data = <<~HEREDOC
            code,name
            "01","Autonomous Communitiy 1"
            "02","Autonomous Communitiy 2"
            "03","Autonomous Communitiy 3
        HEREDOC
        csv = StringIO.new(csv_data)
        puts csv.read
        importer.importCSV csv

        # This works
        # csv = csv_example('correct_example_1')
        # importer.importCSV csv
        
        puts AutonomousCommunity.all.count
        AutonomousCommunity.all.each do |ac|
            puts "code: #{ac.code} name: #{ac.name}"
        end
    end

    context 'malformed csv' do
    end

end