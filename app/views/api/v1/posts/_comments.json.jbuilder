json.comments do
  json.array! comments do |comment|
    json.partial! 'api/v1/comments/comment', comment: comment
  end
end
