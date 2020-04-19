class Api::MunicipalityController < ApplicationController
  def search()
    @municipalities = Municipality.find_by(name: "Calahorra")
  end
end
