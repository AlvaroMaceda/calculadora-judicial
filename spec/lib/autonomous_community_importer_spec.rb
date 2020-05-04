require 'rails_helper'

def ac_data(ac)
    { code: ac.code, name: ac.name, country: ac.country.id}
end

describe DeadlineCalculator do

    let(:country) { create(:country) }
    let(:importer) { AutonomousCommunityImporter.new(country) }

    it 'class exists' do
        expect { AutonomousCommunityImporter }.not_to raise_error
    end

    it 'imports autonomous communities' do
       
        csv_data = <<~HEREDOC
            code,name
            "01","Autonomous Community 1"
            "02","Autonomous Community 2"
            "03","Autonomous Community 3"
        HEREDOC
        expected = [
            {code: '01', name: 'Autonomous Community 1', country: country.id},
            {code: '02', name: 'Autonomous Community 2', country: country.id},
            {code: '03', name: 'Autonomous Community 3', country: country.id}
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        retrieved = AutonomousCommunity.all.to_a.map { |ac| ac_data(ac) }
        expect(retrieved).to match_array(expected)
    end

    context 'errors in csv' do
    end

end