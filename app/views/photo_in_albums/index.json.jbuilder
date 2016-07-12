json.array!(@photo_in_albums) do |photo_in_album|
  json.extract! photo_in_album, :id, :photo_id, :album_id, :display_order
  json.url photo_in_album_url(photo_in_album, format: :json)
end
