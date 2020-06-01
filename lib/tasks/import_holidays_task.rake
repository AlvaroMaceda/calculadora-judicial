require_relative 'holidays_importer_helper'

namespace :import do

    def usage_message(message, task)
        puts <<~HEREDOC 
            #{message}
            Usage:
                rails #{task} YEAR=<year to import>
            or:
                rails #{task} YEAR=All
        HEREDOC
    end
        
    namespace :holidays do

        desc 'DEPRECATED'
        task country: :environment do |task|
            begin
                HolidaysImporterHelper::do_import_country
            rescue HolidaysImporterHelper::InvalidYear => e
                usage_message e.message, task
                next
            end
        end

        desc 'DEPRECATED'
        task ac: :environment do |task|
            begin
                HolidaysImporterHelper::do_import_autonomous_community
            rescue HolidaysImporterHelper::InvalidYear => e
                usage_message e.message, task
                next
            end
        end

        desc 'DEPRECATED'
        task municipality: :environment do |task|
            begin
                HolidaysImporterHelper::do_import_municipality
            rescue HolidaysImporterHelper::InvalidYear => e
                usage_message e.message, task
                next
            end
        end

    end

end