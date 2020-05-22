class ApplicationController < ActionController::Base

    def json_error(message, status=:bad_request)
        render status: status, json: { message: message}
    end

end
