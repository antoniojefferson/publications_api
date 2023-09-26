module AuthSpecHelper
  def include_authenticated_header(token)
    request.headers.merge! 'Authentication': token
  end

  def custom_sign_in(user)
    signing = JOSE::JWK.from_oct(Rails.application.secrets.secret_key_base)
    payload = {
      user_id: user.id, token_type: 'client_app2', exp: 4.hours.from_now.to_i
    }
    signing.sign(payload.to_json, { 'alg' => 'HS256', 'typ' => 'JWT' }).compact
  end
end
