module HolidaysImporterHelper
    
    HOLIDAYS_DIR = File.join('data','holidays')

    class << self
        
        def do_import_country
            do_import 'country',nil
        end

        def do_import_autonomous_community
            do_import 'autonomous_community',nil
        end

        def do_import_municipality
            do_import 'municipality',nil
        end
        
        
        private
        
        def do_import(type, importer)
            year = get_year_parameter

            glob = File.join(get_data_directory(year),"*#{type}*.csv")
            files = Dir.glob(glob)
            if files.empty?
                puts "No holidays found for #{type}; year:#{year}"
                return
            end

            files.each do |filename|
                puts "Importing #{File.basename(filename)}..."
                puts 'TODO'
            end
        end

        def check_integer(str)
            begin
                Integer(str)
            rescue ArgumentError => e
                raise InvalidYear.new(e.message)
            end
        end

        def get_year_parameter
            year = ENV['YEAR']
            raise InvalidYear.new('Missing year') if !year
            
            year = year.upcase
            return year if year.upcase == 'ALL'
            
            check_integer(year)
            return year # As string
        end

        def check_year_parameter(year,task)
            if !year
                puts <<~HEREDOC 
                Usage:
                    rails #{task} YEAR=<year to import>
                or:
                    rails #{task} YEAR=All
                HEREDOC
                return false
            end
            return true
        end

        def get_data_directory(year)
            year = '**' if year=='ALL' 
            File.join(Dir.pwd,HOLIDAYS_DIR,year)
        end

    end # class << self

    class InvalidYear < RuntimeError
    end
end