json.array! @municipalities do |municipality|
  json.code municipality.code
  json.name municipality.name
end