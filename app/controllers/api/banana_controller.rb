class Api::BananaController < ApplicationController

    def index
        render json: {
            :banana => 'Cavendish'
        }.to_json
    end

end