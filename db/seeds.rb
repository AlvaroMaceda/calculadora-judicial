# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require_relative '../lib/holidays_importer_helper'

def destroy_territories
    puts "Destroying territories..."    
    time = benchmark {Territory.destroy_all}
    puts "Territories destroy time: #{time.round(2)} seconds"
end
destroy_territories


def seed_territories
    statistics = nil
    importer = TerritoryImporter.new
    
    puts 'Importing structure...'
    structure = File.join(__dir__,'..','data','territory_structure.csv')
    time = benchmark { statistics = importer.importCSV(structure) }
    puts "Imported #{statistics.imported} structure elements in #{time.round(2)} seconds"

    puts 'Importing municipalities...'
    municipalities = File.join(__dir__,'..','data','municipalities.csv')
    time = benchmark { statistics = importer.importCSV(municipalities) }
    puts "Imported #{statistics.imported} municipalities in #{time.round(2)} seconds"

    puts 'Importing local entities...'
    local_entities = File.join(__dir__,'..','data','local_entities.csv')
    if File.file?(local_entities)
        time = benchmark { statistics = importer.importCSV(local_entities) }
        puts "Imported #{statistics.imported} local entities in #{time.round(2)} seconds"
    else
        puts 'No local entities file found'
    end

end
seed_territories

def seed_holidays
    HolidaysImporterHelper::do_import('ALL')
end
time = benchmark {seed_holidays}
puts "Holidays import time: #{time.round(2)} seconds"