class Api::MunicipalityController < ApplicationController
  def search()
    return [] if params['name'].empty?
    @municipalities = Municipality.similar_to(params['name'])
  end
end
