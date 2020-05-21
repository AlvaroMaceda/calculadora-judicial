require 'rails_helper'

describe MunicipalityImporter do

    let(:es) { create(:country,code:"ES") }
    let(:se) { create(:country,code:"SE") }
    let(:importer) { MunicipalityImporter.new }

    before(:each) do
        create(:autonomous_community,code:"01", country: es)
        create(:autonomous_community,code:"02", country: es)
        create(:autonomous_community,code:"01", country: se)
    end

    it 'imports municipalities' do
        
        csv_data = <<~HEREDOC
            country_code,ac_code,code,name
            "ES","01","ES11001","Villa Arriba"
            "ES","02","ES11002","Villa Abajo"
            "SE","01","SE55555","Villa Villekulla"
        HEREDOC
        expected = [
            {code: 'ES11001', name: 'Villa Arriba',     ac: "01", country: "ES"},
            {code: 'ES11002', name: 'Villa Abajo',      ac: "02", country: "ES"},
            {code: 'SE55555', name: 'Villa Villekulla', ac: "01", country: "SE"}
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_municipalities_in_DB).to match_array(expected)
    end

    it 'works with non-ascii characters' do
       
        csv_data = <<~HEREDOC
            country_code,ac_code,code,name
            "ES","01","ES11001","IIƆS∀ ʇou sᴉ sᴉɥ┴"
        HEREDOC

        expected = [
            {code: 'ES11001', name: 'IIƆS∀ ʇou sᴉ sᴉɥ┴', ac: "01", country: "ES"}
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_municipalities_in_DB).to match_array(expected)
    end

    it 'additional data is ignored' do

        csv_data = <<~HEREDOC
            ignored_1,country_code,ignored_2,ac_code,code,name,ignored_3
            "foo","ES","bar","01","ES11001","Villa Arriba","tee"
            "foo","ES","bar","02","ES11002","Villa Abajo","tee"
            "foo","SE","bar","01","SE55555","Villa Villekulla","tee"
        HEREDOC

        expected = [
            {code: 'ES11001', name: 'Villa Arriba',     ac: "01", country: "ES"},
            {code: 'ES11002', name: 'Villa Abajo',      ac: "02", country: "ES"},
            {code: 'SE55555', name: 'Villa Villekulla', ac: "01", country: "SE"}
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_municipalities_in_DB).to match_array(expected)
    end

    context 'errors' do

        it 'returns errors in csv' do
            csv_data = <<~HEREDOC
                mal "formed
                csv
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CSV::MalformedCSVError)
        end

        it 'returns errors if country not exists' do
            csv_data = <<~HEREDOC
                country_code,ac_code,code,name
                "THIS IS AN ERROR","01","ES11001","Villa Arriba"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
        end

        it 'returns errors if autonomous community not exists' do
            csv_data = <<~HEREDOC
                country_code,ac_code,code,name
                "ES","THIS IS AN ERROR","ES11001","Villa Arriba"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
        end
        
        it 'must have correct country_code header' do
            csv_data = <<~HEREDOC
                THIS_IS_AN_ERROR,ac_code,code,name
                "ES","01","ES11001","Villa Arriba"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::HeadersError)
        end
        
        it 'must have correct ac_code header' do
            csv_data = <<~HEREDOC
                country_code,THIS_IS_AN_ERROR,code,name
                "ES","01","ES11001","Villa Arriba"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::HeadersError)
        end

        it 'must have correct code header' do
            csv_data = <<~HEREDOC
                country_code,ac_code,THIS_IS_AN_ERROR,name
                "ES","01","ES11001","Villa Arriba"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::HeadersError)
        end


        it 'must have correct name header' do
            csv_data = <<~HEREDOC
                country_code,ac_code,THIS_IS_AN_ERROR,name
                "ES","01","ES11001","Villa Arriba"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::HeadersError)
        end

        it 'imports no records if there is an error' do
            csv_data = <<~HEREDOC
                country_code,ac_code,code,name
                "ES","01","ES11001","Villa Arriba"
                "ES","02","ES11002","Villa Abajo"
                "THIS_SHOULD_FAIL","01","SE55555","Villa Villekulla"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
            expect(all_municipalities_in_DB).to match_array([])
        end

        it 'returns error if file does not exist' do
            csv_file = File.join(__dir__,'THIS_FILE_DOES_NOT_EXIST.csv')        

            expect {importer.importCSV csv_file}.to raise_error(CsvBasicImporter::ImportError)
        end

    end

end