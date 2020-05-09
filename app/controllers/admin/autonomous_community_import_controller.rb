require './lib/autonomous_community_importer'

class Admin::AutonomousCommunityImportController < ApplicationController

    def new
        puts 'ejecutando new'
        # puts AutonomousCommunityImporter::banana
    end

    def import

        begin
            country = Country.find(params[:country])
        rescue ActiveRecord::RecordNotFound => e
            flash[:error] = "Country with id:#{params[:country]} does not exist"
            redirect_to action: 'new' and return
        end

        importer = AutonomousCommunityImporter.new(country)
        csv_file = params[:csv_file].tempfile

        begin
            importer.importCSV(csv_file)
        rescue AutonomousCommunityImporter::Error => e
            flash[:error] = "Error in csv file:#{e.message}"
            redirect_to action: 'new' and return
        end
        

        flash[:notice] = "File uploaded. Name: #{params[:csv_file].original_filename}"
        redirect_to action: 'new'
    end

end

