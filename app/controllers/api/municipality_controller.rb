class Api::MunicipalityController < ApplicationController
  def search()
    @municipalities = Municipality.all
    puts @municipalities
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

    # render json: dummy2
    # render :search
    # render formats: :json
    # render :json
    puts 'about to render'
    puts render_to_string
    render
    # puts render_to_string 'api/municipality/search.json.jbuilder'
    # render 'api/municipality/search.json.jbuilder'
  end
end
