json.array!(@albums) do |album|
  json.partial!(album)
end
