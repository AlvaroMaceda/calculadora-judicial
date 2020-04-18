json.municipalities @municipalities do |municipality|
  json.code municipality.code
  json.name municipality.name
  json.autonomous_community_id municipality.autonomous_community.id
end

# json.array! @municipalities do |municipality|
#   json.code municipality.code
#   json.name municipality.name
# end