require_relative '../helpers'
require_relative 'holidays_importer_helper'

namespace :import do

    def usage_message(task)
        puts <<~HEREDOC 
            Usage:
                rails #{task} YEAR=<year to import>
            or:
                rails #{task} YEAR=All
        HEREDOC
    end

    def check_integer(str)
        begin
            Integer(str)
        rescue ArgumentError => e
            return nil
        end
        return str
    end

    def get_year_parameter
        year = ENV['YEAR']
        return nil if !year
        
        year = year.upcase
        return year if year.upcase == 'ALL'
        
        return check_integer(year)
    end
    
    desc 'Import holidays from data/holidays directory. You can speficy a year.'
    task holidays: :environment do |task|

        message = <<~HEREDOC
            WARNING! DESTRUCTIVE ACTION!
            This will DESTROY current holidays and import new ones from data/holidays directories
        HEREDOC
        # next unless confirm(message)

        year = get_year_parameter
        if !year
            usage_message(task) 
            next
        end
        HolidaysImporterHelper::do_import(year)

    end

end