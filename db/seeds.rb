# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Wipe countries, autonomous communities, municipalities and holidays
Holiday.destroy_all
Municipality.destroy_all
AutonomousCommunity.destroy_all
Country.destroy_all

spain = Country.create(name: 'Spain', code: "ES")

def benchmark
    start = Time.now
    yield
    Time.now - start # Returns time taken to perform func
end

def seed_autonomous_communities
    filename = File.join(__dir__,'..','data','autonomous_communities.csv')
    ac_importer = AutonomousCommunityImporter.new
    ac_importer.importCSV(filename)
end
time = benchmark {seed_autonomous_communities}
puts "Autonomous communities import time: #{time}"

def seed_municipalities
    filename = File.join(__dir__,'..','data','municipalities.csv')
    municipality_importer = MunicipalityImporter.new
    municipality_importer.importCSV(filename)
end
time = benchmark {seed_municipalities}
puts "Municipalities import time: #{time}"

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