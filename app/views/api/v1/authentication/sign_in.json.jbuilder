json.token @jwt_token

json.user do
  json.partial! 'api/v1/users/user', user: @user
end