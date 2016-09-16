json.array!(@users) do |user|
  json.(user, :id, :display_name, :roles)
  json.url user_url(user)
end
