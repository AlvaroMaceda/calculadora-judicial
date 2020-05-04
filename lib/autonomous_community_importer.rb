require 'csv'

class AutonomousCommunityImporter

    def initialize(country)
        @country = country
    end

    def importCSV(csv_file)
        csv = CSV.new(csv_file, :headers => true) 
        csv.each do |row|
            create_ac row
        end
    end

    private

    def create_ac(row_data)
        curated_row = {
            country_id: @country.id+0,
            name: row_data['name'],
            code: row_data['code']
        }
        ac = AutonomousCommunity.create(curated_row.to_h)
        # puts ac.valid?
        # ac.errors.full_messages.each do |message|
        #     # do stuff for each error
        #     puts message
        # end
    end
end