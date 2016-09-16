json.(comment, :id)
json.author do |json|
  comment.author ? json.partial!(comment.author) : json.null!
end
json.(comment, :content, :created_at, :updated_at)