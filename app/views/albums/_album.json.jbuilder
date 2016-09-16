json.(album, :id, :name)
json.owner do |json|
  album.owner ? json.partial!(album.owner) : json.null!
end
json.url album_url(album)