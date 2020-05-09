require './lib/autonomous_community_importer'

class Admin::AutonomousCommunityImportController < ApplicationController

  def new
    puts 'ejecutando new'
    # puts AutonomousCommunityImporter::banana
  end

  def import
    country = Country.find(params[:country])
    importer = AutonomousCommunityImporter.new(country)
    
    csv_file = params[:csv_file].tempfile
    importer.importCSV(csv_file)

    flash[:notice] = "File uploaded. Name: #{params[:csv_file].original_filename}"
    redirect_to action: 'new'
  end

end

