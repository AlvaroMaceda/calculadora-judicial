
class AutonomousCommunityImporter

    include CsvBasicImporter

    def initialize()
        @country_ids = {}
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
                country_id: get_country_id(row_data['country_code']),
                name: row_data['name'],
                code: row_data['code']
            }
            ac = AutonomousCommunity.create!(curated_row.to_h)

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

    def get_country_id(code)
        @country_ids[code] || find_country_id(code)
    end

    def find_country_id(code)
        country = Country.find_by(code: code)
        raise CountryNotFound.new("Country code: '#{code}'") unless country
        cache_country_id(code,country.id)
        return country.id
    end

    def cache_country_id(code, country_id)
        @country_ids[code] = country_id
    end

    class CountryNotFound < RuntimeError
    end

end