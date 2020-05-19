class Admin::AutonomousCommunityImportController < ApplicationController

    def new
    end

    def import

        importer = AutonomousCommunityImporter.new
        csv_file = params[:csv_file].tempfile
        csv_file.set_encoding 'UTF-8'

        begin
            importer.importCSV(csv_file)
        rescue AutonomousCommunityImporter::Error => e
            flash[:error] = "Error in csv file:#{e.message}"
            redirect_to action: 'new' and return
        end
        
        message = <<~HEREDOC
                MESSAGE HERE
                #{'banana'}
            HEREDOC
        flash[:notice] = "File uploaded. Name: #{params[:csv_file].original_filename}"
        redirect_to action: 'new'
    end

end

