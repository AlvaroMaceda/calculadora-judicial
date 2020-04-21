class Api::MunicipalityController < ApplicationController
  def search()
    @municipalities = Municipality.similar_to(params['name'])
  end
end
