json.array!(@photos) do |photo|
  if photo.valid?
    json.extract! photo, :id, :image, :description
    json.url album_photo_url(@album, photo, format: :json)
  else
    json.errors photo.errors.messages
  end
end
