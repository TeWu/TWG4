json.(@photo, :id)
json.partial!('image', photo: @photo)
json.(@photo, :description, :created_at, :updated_at)

json.prev prev_photo_url(@album, @photo, anchor: nil)
json.next next_photo_url(@album, @photo, anchor: nil)

json.comments do |json|
  json.array!(@comments) do |comment|
    json.partial!(comment)
  end
end
