json.id user.id
json.name user.name
json.email user.email
json.posts do
  json.array! user.posts do |post|
    json.partial! 'api/v1/posts/post', post: post
  end
end
