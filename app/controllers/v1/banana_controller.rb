class V1::BananaController < ApplicationController

    def index
        render json: {
            :banana => 'Cavendish'
        }.to_json
    end

end