json.array!(@photos) do |photo|
  json.extract! photo, :id, :path, :description
  json.url photo_url(photo, format: :json)
end
