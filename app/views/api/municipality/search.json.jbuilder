json.municipalities @municipalities do |municipality|
  json.code municipality.code
  json.name municipality.name
  json.ac_id municipality.autonomous_community.id
end