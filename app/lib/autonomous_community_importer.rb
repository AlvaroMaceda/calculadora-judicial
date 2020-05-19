# require 'csv'
require_relative '../../tmp/csv'

class AutonomousCommunityImporter

    def initialize()
        @country_ids = {}
    end

    def importCSV(csv_filename_or_io)        
        csv_io = get_io_from_parameter(csv_filename_or_io)
        begin
            line = 1
            imported = 0
            headers_row = true

            #--------------------------------------------------
            # METHOD 1
            #--------------------------------------------------
            # AutonomousCommunity.transaction do
            #     CSV.foreach(csv_io, headers: true) do |row|
            #         if headers_row
            #             validate_headers row.headers
            #             headers_row = false
            #         end
            #         line += 1                    
            #         create_autonomous_community row
            #         imported +=1
            #     end
            # end # Transaction

            #--------------------------------------------------
            # METHOD 2
            #--------------------------------------------------
            csv = CSV.new(csv_io, headers: true, return_headers: true, encoding: 'UTF-8')
            # :encoding
            # Maybe I should do it with read instead of new
            # file_contents = CSV.read("csvfile.csv", col_sep: "$", encoding: "ISO8859-1")
            
            headers = csv.first
            validate_headers headers

            AutonomousCommunity.transaction do
                csv.each do |row|
                    line += 1                    
                    create_autonomous_community row
                    imported +=1
                end
            end
        
            total_lines = line
            return ImportResults.new(total_lines, imported)


        rescue ImportError,CountryNotFound => e
            # message = "Line #{csv.lineno}. " + e.message
            message = "Line #{line}. " + e.message
            raise ImportError.new(message)
        end
    end

    private

    def get_io_from_parameter(filename_or_io)
        if is_a_file_name? filename_or_io
            puts 'its a filename'
            return open_file(filename_or_io)
        else
            puts 'its an io'
            return filename_or_io
        end
    end

    def is_a_file_name?(parameter)
        parameter.instance_of? String
    end

    def open_file(filename)
        begin
            puts 'opening file'
            return File.open(filename, "r:UTF-8")
        rescue SystemCallError => e
            raise ImportError.new("Imput/Output error: #{e.message}")
        end        
    end

    def validate_headers(headers)
        # columns = headers.to_h.keys
        columns = headers
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
                country_id: get_country_id(FORCE_FUCKING_ENCODING_TO_UTF8(row_data['country_code'])),
                name: FORCE_FUCKING_ENCODING_TO_UTF8(row_data['name']),
                code: FORCE_FUCKING_ENCODING_TO_UTF8(row_data['code'])
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

    def FORCE_FUCKING_ENCODING_TO_UTF8(value)
        return value
        # value.encode(value.encoding).force_encoding("utf-8")
        value.encode("utf-8")
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

end