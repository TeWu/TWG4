json.(@user, :id, :display_name, :username, :roles, :created_at, :updated_at)
json.owned_albums do |json|
  json.array!(@user.owned_albums) do |album|
    json.(album, :id, :name)
    json.url album_url(album)
  end
end
json.owned_photos_count @user.owned_photos.count
json.comments_count @user.comments.count
