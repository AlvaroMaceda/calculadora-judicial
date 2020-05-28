
class MunicipalityImporter

    include CsvBasicImporter

    def initialize()
        @country_ids = {}
        @autonomous_community_ids = {}
    end

    private

    def process_row(row)
        create_municipality row
    end

    def expected_headers
        ['country_code', 'ac_code', 'code', 'name']
    end

    def create_municipality(row_data)
        begin
            country_id = get_country_id(row_data['country_code'])
            ac_id = get_autonomous_community_id(country_id, row_data['ac_code'])
            curated_row = {
                autonomous_community_id: ac_id,
                name: row_data['name'],
                code: row_data['code']
            }
            ac = Municipality.create!(curated_row.to_h)

        rescue ActiveRecord::RecordInvalid => e
            message = <<~HEREDOC
                Error creating municipality: 
                #{row_data.to_s.chomp}
                #{curated_row.except(:country_id)}
                #{e.message}
            HEREDOC
            
            raise ImportError.new(message)

        rescue DataNotFound => e
            message = <<~HEREDOC
                Element not found: 
                #{row_data.to_s.chomp}
                #{e.message}
            HEREDOC
            
            raise ImportError.new(message)
        end
    end

    def get_autonomous_community_id(country_id, code)
        id = @autonomous_community_ids[{country_id: country_id, code: code}]
        id || find_autonomous_community_id(country_id, code)
    end

    def find_autonomous_community_id(country_id, code)
        ac = AutonomousCommunity.find_by(country_id: country_id, code: code)
        raise AutonomousCommunityNotFound.new("Autonomous community not found. Code: '#{code}'") unless ac
        cache_autonomous_community_id(country_id, code, ac.id)
        return ac.id
    end

    def cache_autonomous_community_id(country_id, code, ac_id)
        @autonomous_community_ids[{country_id: country_id, code: code}] = ac_id
    end

    def get_country_id(code)
        @country_ids[code] || find_country_id(code)
    end

    def find_country_id(code)
        country = Country.find_by(code: code)
        raise CountryNotFound.new("Country not found. Code: '#{code}'") unless country
        cache_country_id(code,country.id)
        return country.id
    end

    def cache_country_id(code, country_id)
        @country_ids[code] = country_id
    end

    class ImportResults
        attr_reader :lines, :imported
        def initialize(lines, imported)
            @lines = lines
            @imported = imported
        end
    end

    class DataNotFound < RuntimeError
    end

    class CountryNotFound < DataNotFound
    end

    class AutonomousCommunityNotFound < DataNotFound
    end

end