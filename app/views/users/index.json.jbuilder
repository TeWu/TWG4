json.array!(@users) do |user|
  json.extract! user, :id, :display_name, :username, :passhash
  json.url user_url(user, format: :json)
end
