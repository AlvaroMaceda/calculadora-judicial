require 'rails_helper'

def ac_data(ac)
    { code: ac.code, name: ac.name, country: ac.country.id}
end

def all_acs_in_DB()
    AutonomousCommunity.all.to_a.map { |ac| ac_data(ac) }
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
        expect(all_acs_in_DB).to match_array(expected)
    end
    
    it 'additional data is ignored' do
        csv_data = <<~HEREDOC
            ignored1,code,name,ignored2,ignored3
            "foo","01","Autonomous Community 1",99,88
            "bar","02","Autonomous Community 2",77,66
            "tee","03","Autonomous Community 3",55,44
        HEREDOC

        expected = [
            {code: '01', name: 'Autonomous Community 1', country: country.id},
            {code: '02', name: 'Autonomous Community 2', country: country.id},
            {code: '03', name: 'Autonomous Community 3', country: country.id}
        ]

        csv = StringIO.new(csv_data)
        importer.importCSV csv

        retrieved = AutonomousCommunity.all.to_a.map { |ac| ac_data(ac) }
        expect(all_acs_in_DB).to match_array(expected)
    end

    context 'errors' do

        it 'returns errors in csv' do
            csv_data = <<~HEREDOC
                code,name
                "01","A,Treme ndous,error
                "THIS_IS_AN_ERROR","Autonomous Community 2"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CSV::MalformedCSVError)
        end


        it 'returns errors in autonomous community data' do
            csv_data = <<~HEREDOC
                code,name
                "01","Autonomous Community 1"
                "THIS_IS_AN_ERROR","Autonomous Community 2"
            HEREDOC

            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::ImportError)
        end
        
        it 'must have correct code header' do
            csv_data = <<~HEREDOC
                THIS_IS_AN_ERROR,name
                "01","Autonomous Community 1"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::HeadersError)
        end

        it 'must have correct name header' do
            csv_data = <<~HEREDOC
                code,THIS_IS_AN_ERROR
                "01","Autonomous Community 1"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(AutonomousCommunityImporter::HeadersError)
        end

    end

end