require 'csv'

module CsvBasicImporter
    
    # This method expects UTF-8 encoded files, but do not validate it
    def importCSV(csv_filename_or_io)

        csv_io = get_io_from_parameter(csv_filename_or_io)

        begin

            csv = CSV.new(csv_io, headers: true, return_headers: true, encoding: 'UTF-8')
            
            line = 1
            imported = 0

            headers = csv.first
            raise ImportError.new("File is empty.") if headers == nil
            validate_headers headers

            ActiveRecord::Base.transaction do
                csv.each do |row|
                    line += 1
                    call_process_row row
                    imported +=1
                end
            end
        
            total_lines = line
            return ImportResults.new(total_lines, imported)

        rescue ImportError => e
            message = "Line #{line}. " + e.message
            raise ImportError.new(message)
        end
    end

    private 

    def expected_headers
        []
    end

    def optional_headers
        []
    end

    def filter_headers(row)
        expected = expected_headers + optional_headers
        row.slice(*expected) unless expected.empty?
    end

    def call_process_row(row)
        process_row filter_headers(row.to_h)
    end

    def process_row(row)
        raise ImportError.new('You must define process_row method for importer')
    end

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
        expected_headers.each do |column|
            if !headers.include? column
                raise HeadersError.new("Missing column '#{column}'")
            end
        end
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

end