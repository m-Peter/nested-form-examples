json.array!(@ships) do |ship|
  json.extract! ship, :id, :name, :crew, :has_astromech, :speed, :armament
  json.url ship_url(ship, format: :json)
end
