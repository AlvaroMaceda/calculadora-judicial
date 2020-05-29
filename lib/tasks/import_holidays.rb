HOLIDAYS_DIR = File.join('data','holidays')

namespace :import do

    namespace :holidays do

        def is_integer(str)
            begin
                Integer(str)
            rescue ArgumentError => e
                return false
            end
            return true
        end

        def get_year_parameter
            year = ENV['YEAR']
            return nil if !year
            
            year = year.upcase
            return year if year.upcase == 'ALL'
            
            return nil unless is_integer(year)

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

        # Extract this to be use in db:seed
        def do_import(type, importer)
            year = get_year_parameter
            return unless check_year_parameter(year,task)

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

        task :country do |task|
            do_import('country',nil)
        end

        task :ac do |task|
            do_import('autonomous_community',nil)
        end

        task :municipality do |task|
            do_import('municipality',nil)
        end

    end

end