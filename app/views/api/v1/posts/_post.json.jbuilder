json.id post.id
json.title post.title
json.text post.text
json.partial! 'api/v1/posts/comments', comments: post.comments
