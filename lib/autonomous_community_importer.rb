require 'csv'

class AutonomousCommunityImporter

    def initialize()
        @country_ids = {}
    end

    def importCSV(csv_file)
        begin
            csv = CSV.new(csv_file, headers: true, return_headers: true)            
            
            headers = csv.first
            validate_headers headers

            AutonomousCommunity.transaction do
                csv.each do |row|
                    create_autonomous_community row
                end
            end

        rescue ImportError,CountryNotFound => e
            message = "Line #{csv.lineno}. " + e.message
            raise ImportError.new(message)
        end
    end

    private

    def validate_headers(headers)
        columns = headers.to_h.keys
        if !columns.include? 'country_code'
            raise HeadersError.new("Missing column 'country_code'")
        end        
        if !columns.include? 'code'
            raise HeadersError.new("Missing column 'code'")
        end
        if !columns.include? 'name'
            raise HeadersError.new("Missing column 'name'")
        end
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
            
            raise ImportError.new(message)

        rescue CountryNotFound => e
            message = <<~HEREDOC
                Country not found: 
                #{row_data.to_s.chomp}
                #{e.message}
            HEREDOC
            
            raise ImportError.new(message)
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

    class Error < RuntimeError
    end

    class HeadersError < Error
    end

    class ImportError < Error
    end

    class CountryNotFound < Error
    end

end