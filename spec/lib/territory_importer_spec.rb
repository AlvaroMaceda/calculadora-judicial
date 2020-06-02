require 'rails_helper'

describe TerritoryImporter do

    let(:importer) { TerritoryImporter.new }


    it 'imports territories without parent' do
        
        csv_data = <<~HEREDOC
            parent_code,kind,code,name
            "","country",CTES,"Spain"
            "","autonomous_community",AC01,"Andalucía"
            "","island",ISHIE,"El Hierro"
            "","region",REARAN,"Val d'Aran"
            "","municipality",ES26036,"Calahorra"
        HEREDOC
        expected = [
            {kind: :country, code: 'CTES', name: 'Spain', parent: '', population: 0, court: :no},
            {kind: :autonomous_community, code: 'AC01',  name: 'Andalucía', parent: '', population: 0, court: :no},
            {kind: :island, code: 'ISHIE', name: 'El Hierro', parent: '', population: 0, court: :no},
            {kind: :region, code: 'REARAN', name: "Val d'Aran", parent: '', population: 0, court: :no},
            {kind: :municipality, code: 'ES26036', name: 'Calahorra', parent: '', population: 0, court: :no},
        ]
        
        csv = StringIO.new(csv_data)
        importer.importCSV csv
        
        expect(all_territories_in_DB).to match_array(expected)
    end

    it 'imports territories with parent' do
        
        csv_data = <<~HEREDOC
            parent_code,kind,code,name
            "","country",CTES,"Spain"
            "CTES","autonomous_community",AC01,"Andalucía"
            "AC01","island",ISHIE,"El Hierro"
            "ISHIE","region",REARAN,"Val d'Aran"
            "REARAN","municipality",ES26036,"Calahorra"
        HEREDOC
        expected = [
            {kind: :country, code: 'CTES', name: 'Spain', parent: '', population: 0, court: :no},
            {kind: :autonomous_community, code: 'AC01',  name: 'Andalucía', parent: 'CTES', population: 0, court: :no},
            {kind: :island, code: 'ISHIE', name: 'El Hierro', parent: 'AC01', population: 0, court: :no},
            {kind: :region, code: 'REARAN', name: "Val d'Aran", parent: 'ISHIE', population: 0, court: :no},
            {kind: :municipality, code: 'ES26036', name: 'Calahorra', parent: 'REARAN', population: 0, court: :no},
        ]
        
        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_territories_in_DB).to match_array(expected)
    end

    it 'can import population and court for municipalities' do
        
        csv_data = <<~HEREDOC
            parent_code,kind,code,name,population,court
            "","municipality",ES00001,"Calahorra",1234,N
            "","municipality",ES00002,"Bilbao",1000000000,S
        HEREDOC
        expected = [
            {kind: :municipality, code: 'ES00001', name: 'Calahorra', parent: '', population: 1234, court: :no},
            {kind: :municipality, code: 'ES00002', name: 'Bilbao', parent: '', population: 1000000000, court: :have},
        ]
        
        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_territories_in_DB).to match_array(expected)
    end

    context 'errors' do

        it 'raises error if record is not valid' do
            csv_data = <<~HEREDOC
                parent_code,kind,code,name
                "REARAN","INVALID_KIND",ES26036,"Calahorra"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
        end

        it 'raises errors if parent territory not exists' do
            csv_data = <<~HEREDOC
                parent_code,kind,code,name
                "THIS_NOT_EXISTS","municipality",ES26036,"Calahorra"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
        end

        it 'imports no records if there is an error' do
            csv_data = <<~HEREDOC
                parent_code,kind,code,name
                "","country",CTES,"Spain"
                "","country",CTNE,"Nevermore"
                "ASEREJE_A_DEJE_A_SERE_JERINDONGA","country",TERRIBLE_ERROR_HERE,"Serindonga"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
            expect(all_territories_in_DB).to match_array([])
        end

    end


end