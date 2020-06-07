require 'rails_helper'

describe HolidaysImporter do

    let(:importer) { HolidaysImporter.new }

    before(:each) do
        create(:territory, kind: :country, code: 'CT_ESP')
        create(:territory, kind: :autonomous_community, code: 'AC00001')
        create(:territory, kind: :municipality, code: 'ES26036')
    end

    it 'imports territory holidays' do
        csv_data = <<~HEREDOC
            code,date
            CT_ESP,03/03/2020
            AC00001,03/03/2020
            ES26036,03/03/2020
            ES26036,04/04/2020
        HEREDOC

        expected = [
            {code: 'CT_ESP', date: Date.parse('2020-03-03') },
            {code: 'AC00001', date: Date.parse('2020-03-03') },
            {code: 'ES26036', date: Date.parse('2020-03-03') },
            {code: 'ES26036', date: Date.parse('2020-04-04') }
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_holidays_in_DB).to match_array(expected)
    end

    it 'skip rows without date' do
        csv_data = <<~HEREDOC
            code,date
            CT_ESP,03/03/2020
            AC00001,
            ES26036,""
            ES26036,04/04/2020
        HEREDOC

        expected = [
            {code: 'CT_ESP', date: Date.parse('2020-03-03') },
            {code: 'ES26036', date: Date.parse('2020-04-04') }
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_holidays_in_DB).to match_array(expected)
    end

    context 'errors' do

        it 'returns errors if territory does not exist' do
            csv_data = <<~HEREDOC
                code,date
                THIS_NOT_EXISTS,03/03/2020
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError, /Territory not found/)
        end

        it 'returns error if date in csv is invalid' do
            csv_data = <<~HEREDOC
                code,date
                CT_ESP,55/55/5555
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError, /Invalid date/)
        end

        it 'returns error if can\t create the holiday' do
            csv_data = <<~HEREDOC
                code,date
                CT_ESP,03/03/2020
                CT_ESP,03/03/2020
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError,/Error creating holiday/)
        end

        it 'imports no records if there is an error' do
            csv_data = <<~HEREDOC
                code,date
                CT_ESP,03/03/2020
                AC00001,03/03/2020
                ES26036,03/03/2020
                THIS SHOULD FAIL,BADLY
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
            expect(all_holidays_in_DB).to match_array([])
        end

    end        

end