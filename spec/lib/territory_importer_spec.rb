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
            {kind: "country", code: 'CTES', name: 'Spain', parent: ''},
            {kind: "autonomous_community", code: 'AC01',  name: 'Andalucía', parent: ''},
            {kind: "island", code: 'ISHIE', name: 'El Hierro', parent: ''},
            {kind: "region", code: 'REARAN', name: "Val d'Aran", parent: ''},
            {kind: "municipality", code: 'ES26036', name: 'Calahorra', parent: ''},
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
            {kind: "country", code: 'CTES', name: 'Spain', parent: ''},
            {kind: "autonomous_community", code: 'AC01',  name: 'Andalucía', parent: 'CTES'},
            {kind: "island", code: 'ISHIE', name: 'El Hierro', parent: 'AC01'},
            {kind: "region", code: 'REARAN', name: "Val d'Aran", parent: 'ISHIE'},
            {kind: "municipality", code: 'ES26036', name: 'Calahorra', parent: 'REARAN'},
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