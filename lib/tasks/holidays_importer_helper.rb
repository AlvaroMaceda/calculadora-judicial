# require_relative '../../app/lib/country_holidays_importer'

module HolidaysImporterHelper
    
    HOLIDAYS_DIR = File.join('data','holidays')

    class << self
        
        def do_import_country
            importer = CountryHolidaysImporter.new
            do_import 'country',importer
        end

        def do_import_autonomous_community
            importer = AutonomousCommunityHolidaysImporter.new
            do_import 'autonomous_community',importer
        end

        def do_import_municipality
            do_import 'municipality',nil
        end        
        
        private

        def delete_all_holidays(type)
            puts "Deleting all holidays for #{type}..."
            Holiday.where(holidayable_type: type).destroy_all
        end

        def delete_year_holidays(type,year)
            Holiday.where(
                holidayable_type: type, 
                date: Date.new(year.to_i,1,1)..Date.new(year.to_i,12,31)
            ).destroy_all
        end

        def delete_previous_holidays(type, year)
            if year == 'ALL'
                delete_all_holidays type
            else
                delete_year_holidays type, year
            end
        end
        
        def do_import(type, importer)
            year = get_year_parameter

            glob = File.join(get_data_directory(year),"*#{type}*.csv")
            files = Dir.glob(glob)
            if files.empty?
                puts "No holidays found for #{type}; year:#{year}"
                return
            end

            delete_previous_holidays :Country, year
            files.each do |filename|
                puts "Importing #{File.basename(filename)}..."
                res = importer.importCSV filename
                puts "Imported #{res.imported} #{type} holidays"
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