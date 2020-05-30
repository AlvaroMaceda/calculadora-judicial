require 'rails_helper'

describe CountryHolidaysImporter do

    before { skip }

    let(:importer) { CountryHolidaysImporter.new }
    
    before(:each) do
        es =  create(:country,code:"ES")
        se =  create(:country,code:"SE")   
    end

    it 'imports country holidays' do
        csv_data = <<~HEREDOC
            code,date
            ES,01/05/2020
            ES,15/08/2020
            SE,12/10/2020
        HEREDOC

        expected = [
            {code: 'ES', date: Date.parse('2020-05-01'), type: 'Country' },
            {code: 'ES', date: Date.parse('2020-08-15'), type: 'Country' },
            {code: 'SE', date: Date.parse('2020-10-12'), type: 'Country' }
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_holidays_in_DB_of_type(:Country)).to match_array(expected)
    end

    context 'errors' do

        it 'returns errors if country not exists' do
            csv_data = <<~HEREDOC
                code,date
                ZZ,01/05/2020
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
        end

        it 'returns error if date in csv is invalid' do
            csv_data = <<~HEREDOC
                code,date
                ES,99/99/9999
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
        end

        it 'returns error if can\t create the holiday' do
            # 31/5/2020 is sunday
            csv_data = <<~HEREDOC
                code,date
                ES,31/5/2020
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
        end

        it 'imports no records if there is an error' do
            csv_data = <<~HEREDOC
                code,date
                ES,01/05/2020
                ES,15/08/2020
                THIS_SHOULD_FAIL,12/10/2020
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
            expect(all_holidays_in_DB).to match_array([])
        end

    end
end