json.array!(@songs) do |song|
  json.extract! song, :id, :title, :length
  json.url song_url(song, format: :json)
end
