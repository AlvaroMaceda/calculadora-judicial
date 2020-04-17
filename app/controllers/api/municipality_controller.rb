class Api::MunicipalityController < ApplicationController
  def search
    render json: {
      :municipality => 'search'
    }.to_json
  end
end
