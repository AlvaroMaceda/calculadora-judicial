class Api::MunicipalityController < ApplicationController

  NAME_FIELD_WITHOUT_SPACES = "LOWER(REPLACE(`name`, ' ', ''))"

  def search()
    search_expression = ".*#{params['name'].downcase}.*"
    
    @municipalities = Municipality.where(
      "#{NAME_FIELD_WITHOUT_SPACES} REGEXP ?", search_expression
    )
  end
end
