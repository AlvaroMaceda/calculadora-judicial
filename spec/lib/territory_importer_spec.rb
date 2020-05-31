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


end