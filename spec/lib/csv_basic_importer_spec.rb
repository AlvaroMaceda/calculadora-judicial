require 'rails_helper'

describe CsvBasicImporter do

    let(:importer) { CsvBasicImporter.new }

    xit 'processes rows' do
    end

    xit 'works with a file name' do
    end

    xit 'additional data is ignored' do
    end

    xit 'works with non-ascii characters' do
    end

    xit 'returns statistics' do
    end

    context 'errors' do

        it 'returns errors in csv' do
        end

        xit 'returns error if data doesn\t have required headers' do
        end

        xit 'imports no records if there is an error' do
        end

        it 'returns error if file does not exist' do
            csv_file = File.join(__dir__,'THIS_FILE_DOES_NOT_EXIST.csv')        

            expect {importer.importCSV csv_file}.to raise_error(CsvBasicImporter::ImportError)
        end

    end

end