class Api::MunicipalityController < ApplicationController
  def search()
    puts params
    dummy = %(
{
  "municipalities": [
    {
      "code": "0005",
      "name": "Calahorra"
    },
    {
      "code": "0006",
      "name": "Bilbao"
    },
    {
      "code": "0005",
      "name": "Cuenca"
    }
  ]
}
    )

    dummy2 = %(
{
  "municipalities": [
    {
      "code": "0005",
      "name": "Calahorra"
    },
    {
      "code": "0006",
      "name": "Bilbao"
    },
    {
      "code": "0005",
      "name": "Cuenca"
    }
  ]
}
          )    

    render json: dummy2

  end
end
