class Api::MunicipalitySearchController < ApplicationController
  
  MINIMUM_CHARACTERS = 3
  
  def search()
    # sleep 3 # For UI testing purposes
    name = params['name']
    return [] if name.empty?
    return json_error "Too few characters to search, minimum #{}" if name.length < MINIMUM_CHARACTERS
    @municipalities = Municipality.similar_to(params['name'])
  end

end
