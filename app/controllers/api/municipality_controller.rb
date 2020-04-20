class Api::MunicipalityController < ApplicationController
  def search()
    search_expression = ".*#{params['name'].downcase}.*"
    @municipalities = Municipality.where(
      "LOWER(REPLACE(`name`, ' ', '')) REGEXP ?", search_expression
    )
=begin
    select name
    from municipalities
    where LOWER(REPLACE(`name`, ' ', '')) REGEXP LOWER('.*Cal.*')
=end
  end
end
