require './lib/autonomous_community_importer'

class Admin::AutonomousCommunityImportController < ApplicationController

  def new
    puts 'ejecutando new'
    puts AutonomousCommunityImporter::banana
  end

  def import
    name = params[:upload][:file].original_filename
    
    # path = File.join("public", "images", "upload", name)
    # File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
    flash[:notice] = "File uploaded. Name: #{name}"
    # redirect_to "/upload/new"
    redirect_to action: 'new'
  end

end

