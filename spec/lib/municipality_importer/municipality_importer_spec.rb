require 'rails_helper'

describe MunicipalityImporter do

  let(:es) { create(:country,code:"ES") }
  let(:fr) { create(:country,code:"FR") }
  let(:importer) { MunicipalityImporter.new }

  before(:each) do
    create(:autonomous_community,code:"01", country: es)
    create(:autonomous_community,code:"02", country: es)
    create(:autonomous_community,code:"01", country: fr)
  end

  it 'imports municipalities', focus:true do
       
    csv_data = <<~HEREDOC
        country_code,ac_code,code,name
        "ES","01","ES11001","Villa Arriba"
        "ES","02","ES11002","Villa Abajo"
        "FR","01","FR55555","Villa Villekulla"
    HEREDOC
    expected = [
        {code: 'ES11001', name: 'Villa Arriba',     ac: "01", country: "ES"},
        {code: 'ES11002', name: 'Villa Abajo',      ac: "02", country: "ES"},
        {code: 'FR55555', name: 'Villa Mangaporhombro', ac: "01", country: "FR"}
    ]

    csv = StringIO.new(csv_data)
    importer.importCSV csv

    expect(all_autonomous_communities_in_DB).to match_array(expected)
end


end