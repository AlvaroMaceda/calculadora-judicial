class Api::MunicipalityController < ApplicationController
  def search()
    search_expression = ".*#{params['name']}.*"
    @municipalities = Municipality.where(
      "name REGEXP ?", search_expression
    )
  end
end
