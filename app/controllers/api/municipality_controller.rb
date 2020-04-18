class Api::MunicipalityController < ApplicationController
  def search()
    @municipalities = Municipality.all
  end
end
