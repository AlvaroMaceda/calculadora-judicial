require 'rails_helper'

describe DeadlineCalculator do

    before(:each) do
        create(:country,code:"ES")
        create(:country,code:"FR")
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
                "GB","01","Autonomous Community 1"
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
    end

end