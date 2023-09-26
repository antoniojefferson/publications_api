class ApplicationController < ActionController::API
  include JwtMethods
  before_action :jwt_auth_validation
end
