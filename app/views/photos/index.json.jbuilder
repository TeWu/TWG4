json.array!(@photos) do |photo|
  if photo.valid?
    json.(photo, :id)
    json.partial!('image', photo: photo)
    json.url album_photo_url(@album, photo, anchor: nil)
  else
    json.errors photo.errors.messages
  end
end
