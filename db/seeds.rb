# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Territories and holidays
# Holiday.destroy_all


def destroy_territories
    puts "Destroying territories..."
    Territory.destroy_all
end
time = benchmark {destroy_territories}
puts "Territories destroy time: #{time} seconds"

def seed_territories
    statistics = nil
    importer = TerritoryImporter.new
    
    puts 'Importing structure...'
    structure = File.join(__dir__,'..','data','territory_structure.csv')
    time = benchmark { statistics = importer.importCSV(structure) }
    puts "Imported #{statistics.imported} structure elements in #{time} seconds"

    puts 'Importing municipalities...'
    municipalities = File.join(__dir__,'..','data','municipalities.csv')
    time = benchmark { statistics = importer.importCSV(municipalities) }
    puts "Imported #{statistics.imported} municipalities in #{time} seconds"
end
seed_territories

def seed_holidays
    base_glob = File.join(__dir__,'..','data','holidays','**')

    Dir.glob(File.join(base_glob,'*country_*.csv')) do |thefile|
        puts "Importing Country holidays: #{File.basename(thefile)}"
        # puts "#{File.basename(thefile)} is at #{File.dirname(thefile)}"  
    end
    Dir.glob(File.join(base_glob,'*autonomous_communities_*.csv')) do |thefile| 
        puts "Importing Autonomous Communities holidays: #{File.basename(thefile)}"
        # puts "#{File.basename(thefile)} is at #{File.dirname(thefile)}"  
    end
    Dir.glob(File.join(base_glob,'*municipalities_*.csv')) do |thefile| 
        puts "Importing Municipality holidays: #{File.basename(thefile)}"
        # puts "#{File.basename(thefile)} is at #{File.dirname(thefile)}"  
    end
end
time = benchmark {seed_holidays}
puts "Holidays import time: #{time}"