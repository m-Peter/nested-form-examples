json.array!(@conferences) do |conference|
  json.extract! conference, :id, :name, :city
  json.url conference_url(conference, format: :json)
end
