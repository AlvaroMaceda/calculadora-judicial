require 'rails_helper'

describe AutonomousCommunityImporter do

    before(:each) do
        create(:country,code:"ES")
        create(:country,code:"FR")
        create(:country,code:"GB")
    end

    let(:importer) { AutonomousCommunityImporter.new }

    it 'class exists' do
        expect { AutonomousCommunityImporter }.not_to raise_error
    end

    it 'imports autonomous communities' do
       
        csv_data = <<~HEREDOC
            country_code,code,name
            "ES","01","Autonomous Community 1"
            "ES","02","Autonomous Community 2"
            "FR","01","Autonomous Community 1"
        HEREDOC
        expected = [
            {code: '01', name: 'Autonomous Community 1', country: "ES"},
            {code: '02', name: 'Autonomous Community 2', country: "ES"},
            {code: '01', name: 'Autonomous Community 1', country: "FR"}
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_autonomous_communities_in_DB).to match_array(expected)
    end
    
    it 'works with non-ascii characters' do
       
        csv_data = <<~HEREDOC
            country_code,code,name
            "ES","01","IIƆS∀ ʇou sᴉ sᴉɥ┴"
        HEREDOC
        expected = [
            {code: '01', name: 'IIƆS∀ ʇou sᴉ sᴉɥ┴', country: "ES"},
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_autonomous_communities_in_DB).to match_array(expected)
    end

    it 'works with a file name' do

        csv_file = File.join(__dir__,'autonomous_community_importer_data','correct_example.csv')        
        expected = [
            {code: '01', name: 'Autonomous Community 1', country: "ES"},
            {code: '02', name: 'Autonomous Community 2', country: "ES"},
            {code: '01', name: 'Autonomous Community 1', country: "GB"}
        ]

        importer.importCSV csv_file

        expect(all_autonomous_communities_in_DB).to match_array(expected)
    end

    it 'returns statistics' do
       
        csv_data = <<~HEREDOC
            country_code,code,name
            "ES","01","Autonomous Community 1"
            "ES","02","Autonomous Community 2"
            "FR","01","Autonomous Community 1"
        HEREDOC

        csv = StringIO.new(csv_data)
        result = importer.importCSV csv

        expect(result.lines).to eq(4)
        expect(result.imported).to eq(3)
    end

    it 'additional data is ignored' do
        csv_data = <<~HEREDOC
            country_code,ignored1,code,name,ignored2,ignored3
            "ES","foo","01","Autonomous Community 1",99,88
            "ES","bar","02","Autonomous Community 2",77,66
            "FR","tee","01","Autonomous Community 1",55,44
        HEREDOC

        expected = [
            {code: '01', name: 'Autonomous Community 1', country: "ES"},
            {code: '02', name: 'Autonomous Community 2', country: "ES"},
            {code: '01', name: 'Autonomous Community 1', country: "FR"}
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_autonomous_communities_in_DB).to match_array(expected)
    end

    context 'errors' do

        it 'returns errors in csv' do
            csv_data = <<~HEREDOC
                country_code,code,name
                "ES","01","A,Treme ndous,error
                "ES","THIS_IS_AN_ERROR","Autonomous Community 2"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CSV::MalformedCSVError)
        end

        it 'returns errors in autonomous community data' do
            csv_data = <<~HEREDOC
                country_code,code,name
                "ES","01","Autonomous Community 1"
                "ES","THIS_IS_AN_ERROR","Autonomous Community 2"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::ImportError)
        end
        
        it 'must have correct code header' do
            csv_data = <<~HEREDOC
                THIS_IS_AN_ERROR,name
                "01","Autonomous Community 1"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::HeadersError)
        end

        it 'must have correct country_code header' do
            csv_data = <<~HEREDOC
                THIS_IS_AN_ERROR,code,name
                "ES","01","Autonomous Community 1"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::HeadersError)
        end

        it 'must have correct name header' do
            csv_data = <<~HEREDOC
                country_code,code,THIS_IS_AN_ERROR
                "ES","01","Autonomous Community 1"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::HeadersError)
        end

        it 'returns error if country does not exists' do
            csv_data = <<~HEREDOC
                country_code,code,name
                "ZZ","01","Autonomous Community 1"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::ImportError)
        end

        it 'imports no records if there is an error' do
            csv_data = <<~HEREDOC
                country_code,code,name
                "ES","01","Autonomous Community 1"
                "ES","02","Autonomous Community 2"
                "OO","xx","ERROR IN THIS RECORD"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::ImportError)
            expect(all_autonomous_communities_in_DB).to match_array([])
        end

        it 'returns error if file does not exist' do
            csv_file = File.join(__dir__,'THIS_FILE_DOES_NOT_EXIST.csv')
    
            expect {importer.importCSV csv_file}.to raise_error(AutonomousCommunityImporter::ImportError)
        end

    end

end