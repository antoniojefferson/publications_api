json.array! @posts do |post|
  json.id post.id
  json.title post.title
  json.text post.text
  json.partial! 'comments', comments: post.comments
end
