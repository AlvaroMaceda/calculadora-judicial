require_relative '../helpers'

namespace :import do

    def do_territory_import(filename)
        importer = TerritoryImporter.new
        statistics = nil # to be used in the block
        time = benchmark {statistics = importer.importCSV(filename)}
        puts "Imported #{statistics.imported} territories in #{time.round(2)} seconds"
    end

    def clean_structure
        puts "Deleting previous data..."
        time = benchmark { Territory.where.not(kind: [:municipality, :local_entity]).destroy_all }
        puts "Data deleted in #{time.round(2)} seconds"
    end

    def clean_municipalities
        puts "Deleting previous data..."
        time = benchmark { Territory.where(kind: [:municipality, :local_entity]).destroy_all }
        puts "Data deleted in #{time.round(2)} seconds"
    end

    desc "DESTROYS structure and imports a new one (country, autonomous community, regions, islands)"
    task structure: :environment do |task|

        message = <<~HEREDOC
            WARNING! DESTRUCTIVE ACTION!
            This will DESTROY current structure AND municipalities and import a new one from data/territory_structure.csv file
        HEREDOC
        next unless confirm(message)

        root_dir = Dir.pwd
        structure_file = File.join(root_dir,'data','territory_structure.csv')

        if !File.file?(structure_file)
            puts 'Structure file does not exist'
            next
        end

        clean_structure
    do_territory_import structure_file
    end

    desc "DESTROYS municipalities and imports new data (structure shold exists in DB)"
    task municipalities: :environment do |task|
        message = <<~HEREDOC
            WARNING! DESTRUCTIVE ACTION!
            This will DESTROY current municipalities and import new ones from data/municipalities.csv and data/local_entities.csv file
        HEREDOC
        next unless confirm(message)

        root_dir = Dir.pwd
        municipalities_file = File.join(root_dir,'data','municipalities.csv')

        if !File.file?(municipalities_file)
            puts 'Municipalities file does not exist'
            next
        end

        clean_municipalities
        do_territory_import municipalities_file      
        
        local_entities_file = File.join(root_dir,'data','local_entities.csv')

        if !File.file?(local_entities_file)
            puts 'Local entities file does not exist'
            next
        else
            do_territory_import local_entities_file 
        end

    end

end
