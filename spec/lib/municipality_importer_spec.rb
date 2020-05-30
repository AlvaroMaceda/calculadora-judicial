require 'rails_helper'

describe MunicipalityImporter do

    let(:importer) { MunicipalityImporter.new }
    
    before(:each) do
        es =  create(:country,code:"ES")
        se =  create(:country,code:"SE")
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

    context 'errors' do

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

    end

end