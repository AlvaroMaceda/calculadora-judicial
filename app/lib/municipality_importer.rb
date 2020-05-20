require 'csv'
class MunicipalityImporter

    def initialize()
        @country_ids = {}
    end

    # This method expects UTF-8 encoded files, but do not validate it
    def importCSV(csv_filename_or_io)

        csv_io = get_io_from_parameter(csv_filename_or_io)

        begin

            csv = CSV.new(csv_io, headers: true, return_headers: true, encoding: 'UTF-8')
            
            headers = csv.first
            validate_headers headers

            line = 1
            imported = 0
            AutonomousCommunity.transaction do
                csv.each do |row|
                    line += 1                    
                    create_municipality row
                    imported +=1
                end
            end
        
            total_lines = line
            return ImportResults.new(total_lines, imported)

        rescue ImportError,CountryNotFound,AutonomousCommunityNotFound => e
            message = "Line #{line}. " + e.message
            raise ImportError.new(message)
        end
    end

    private

    def get_io_from_parameter(filename_or_io)
        if is_a_file_name?(filename_or_io)
            return open_file(filename_or_io)
        else
            return filename_or_io
        end
    end

    def is_a_file_name?(parameter)
        parameter.instance_of? String
    end

    def open_file(filename)
        begin
            return File.open(filename, "r:UTF-8")
        rescue SystemCallError => e
            raise ImportError.new("Imput/Output error: #{e.message}")
        end        
    end

    def validate_headers(headers)
        expected_columns = [
            'country_code', 'ac_code', 'code', 'name'
        ]

        columns = headers
        expected_columns.each do |column|
            if !columns.include? column
                raise HeadersError.new("Missing column '#{column}'")
            end
        end
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

        rescue CountryNotFound => e
            message = <<~HEREDOC
                Country not found: 
                #{row_data.to_s.chomp}
                #{e.message}
            HEREDOC
            
            raise ImportError.new(message)
        end
    end

    def get_autonomous_community_id(country_id, code)
        ac = AutonomousCommunity.find_by(country_id: country_id, code: code)
        raise AutonomousCommunityNotFound.new("Autonomous community code: '#{code}'") unless ac
        return ac.id
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

    class ImportResults
        attr_reader :lines, :imported
        def initialize(lines, imported)
            @lines = lines
            @imported = imported
        end
    end

    class Error < RuntimeError
    end

    class HeadersError < Error
    end

    class ImportError < Error
    end

    class CountryNotFound < Error
    end

    class AutonomousCommunityNotFound < Error
    end

end