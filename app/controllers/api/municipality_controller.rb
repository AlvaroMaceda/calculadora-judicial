class Api::MunicipalityController < ApplicationController
  def search()
    @municipalities = Municipality.where(name: "Calahorra")
  end
end
