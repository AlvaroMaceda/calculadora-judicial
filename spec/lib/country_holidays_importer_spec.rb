require 'rails_helper'

describe CountryHolidaysImporter do
    let(:importer) { CountryHolidaysImporter.new }
    
    before(:each) do
        es =  create(:country,code:"ES")
        se =  create(:country,code:"SE")
        create(:autonomous_community,code:"A1", country: es)
        create(:autonomous_community,code:"A2", country: es)
        create(:autonomous_community,code:"B1", country: se)        
    end

    xit 'imports country holidays' do
        csv_data = <<~HEREDOC
            type,code,date
            country,ES,01/05/2020
            country,ES,15/08/2020
            country,SE,12/10/2020
        HEREDOC

        expected = [
            {type: 'Country', code: 'ES', date: Date.parse('2020-05-01') },
            {type: 'Country', code: 'ES', date: Date.parse('2020-08-15') },
            {type: 'Country', code: 'SE', date: Date.parse('2020-10-12') }
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        expect(all_holidays_in_DB_of_type(:Country)).to match_array(expected)
    end

end