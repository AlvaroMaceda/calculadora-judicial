# require_relative '../../app/lib/country_holidays_importer'

module HolidaysImporterHelper
    
    HOLIDAYS_DIR = File.join('data','holidays')

    class << self
        
        def do_import(year)
            year = year.to_s

            importer = HolidaysImporter.new

            glob = File.join(get_data_directory(year),"*.csv")
            files = Dir.glob(glob)
            if files.empty?
                puts "No holidays found for year:#{year}"
                return
            end

            delete_previous_holidays year
            files.each do |filename|
                puts "Importing #{File.basename(filename)}..."
                res = importer.importCSV filename
                puts "Imported #{res.imported} holidays"
            end
        end

        private

        def delete_all_holidays
            puts "Deleting all holidays..."
            Holiday.destroy_all
        end

        def delete_year_holidays(year)
            Holiday.where(
                date: Date.new(year.to_i,1,1)..Date.new(year.to_i,12,31)
            ).destroy_all
        end

        def delete_previous_holidays(year)
            if year == 'ALL'
                delete_all_holidays
            else
                delete_year_holidays year
            end
        end
        
        def get_data_directory(year)
            year = '**' if year=='ALL' 
            File.join(Dir.pwd,HOLIDAYS_DIR,year)
        end

    end # class << self

end