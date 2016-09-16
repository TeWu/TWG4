json.(@album, :id, :name)
json.owner do |json|
  @album.owner ? json.partial!(@album.owner) : json.null!
end
json.(@album, :created_at, :updated_at)
json.photo_urls @photo_urls
