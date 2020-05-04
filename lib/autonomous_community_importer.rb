require 'csv'

class AutonomousCommunityImporter

    def initialize(country)
        @country = country
    end

    def importCSV(csv_file)
        CSV.new(csv_file, :headers => true) do |row|
            curated_row = {
                country_id: @country.id+0,
                name: row['name'],
                code: row['code']
            }
            puts curated_row
            ac = AutonomousCommunity.create(curated_row.to_h)
            # ac.errors.full_messages.each do |message|
            #     # do stuff for each error
            # end
        end
    end

end