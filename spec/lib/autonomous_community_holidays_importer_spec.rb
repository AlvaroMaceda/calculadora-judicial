require 'rails_helper'

describe AutonomousCommunityHolidaysImporter do
    let(:importer) { AutonomousCommunityHolidaysImporter.new }
    
    before(:each) do
        es =  create(:country,code:"ES")
        se =  create(:country,code:"SE")
        create(:autonomous_community,code:"A1", country: es)
        create(:autonomous_community,code:"A2", country: es)
        create(:autonomous_community,code:"B1", country: se)        
    end

    it 'imports autonomous community holidays' do
        csv_data = <<~HEREDOC
            country_code,code,date
            ES,A1,03/03/2020
            ES,A1,04/04/2020
            SE,B1,04/04/2020
        HEREDOC

        expected = [
            {code: 'A1', date: Date.parse('2020-03-03'), type: 'AutonomousCommunity' },
            {code: 'A1', date: Date.parse('2020-04-04'), type: 'AutonomousCommunity' },
            {code: 'B1', date: Date.parse('2020-04-04'), type: 'AutonomousCommunity' }
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_holidays_in_DB_of_type(:AutonomousCommunity)).to match_array(expected)
    end

    context 'errors' do

        it 'returns errors if country does not exist' do
            csv_data = <<~HEREDOC
                country_code,code,date
                ZZ,A1,01/05/2020
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError, /Country not found/)
        end

        it 'returns errors if autonomous coummunity does not exist' do
            csv_data = <<~HEREDOC
                country_code,code,date
                ES,ZZ,03/03/2020
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError, /Autonomous community not found/)
        end        

        it 'returns error if date in csv is invalid' do
            csv_data = <<~HEREDOC
                country_code,code,date
                ES,A1,55/55/5555
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError, /Invalid date/)
        end

        it 'returns error if can\t create the holiday' do
            csv_data = <<~HEREDOC
                country_code,code,date
                ES,A1,1/2/2020
                ES,A1,1/2/2020
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError,/Error creating country's holiday/)
        end

        it 'imports no records if there is an error' do
            csv_data = <<~HEREDOC
                country_code,code,date
                ES,A1,03/03/2020
                ES,A1,04/04/2020
                THIS SHOULD FAIL
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
            expect(all_holidays_in_DB).to match_array([])
        end

    end
end