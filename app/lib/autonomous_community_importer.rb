
class AutonomousCommunityImporter

    include CsvBasicImporter

    def initialize()
        @country_ids = ItemsCache::create { |code| find_country_id(code)}
    end

    private
    
    def process_row(row)
        create_autonomous_community row
    end

    def expected_headers
        ['country_code','code','name']
    end
    
    def create_autonomous_community(row_data)
        begin
            curated_row = {
                country_id: @country_ids[row_data['country_code']],
                name: row_data['name'],
                code: row_data['code']
            }
            AutonomousCommunity.create!(curated_row.to_h)

        rescue ActiveRecord::RecordInvalid => e
            message = <<~HEREDOC
                Error creating autonomous community: 
                #{row_data.to_s.chomp}
                #{curated_row.except(:country_id)}
                #{e.message}
            HEREDOC
            
            raise CsvBasicImporter::ImportError.new(message)

        rescue CountryNotFound => e
            message = <<~HEREDOC
                Country not found: 
                #{row_data.to_s.chomp}
                #{e.message}
            HEREDOC
            
            raise CsvBasicImporter::ImportError.new(message)
        end
    end

    def find_country_id(code)
        country = Country.find_by(code: code)
        raise CountryNotFound.new("Country code: '#{code}'") unless country
        return country.id
    end

    class CountryNotFound < RuntimeError
    end

end