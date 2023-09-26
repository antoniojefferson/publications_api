module JwtMethods
  extend ActiveSupport::Concern

  def jwt_decode(jwt_hash)
    verified, message, = signing_token.verify(jwt_hash)
    decoded = JSON.parse(message)
    decoded['invalid'] = true unless verified
    decoded
  end

  def jwt_encode(payload = {})
    signing_token.sign(payload.to_json, { 'alg' => 'HS256', 'typ' => 'JWT' }).compact
  end

  def jwt_invalid_payload(payload)
    payload['token_type'].blank? || payload['token_type'].present? && payload['token_type'] != 'client_app2'
  end

  def jwt_time(hours = 4)
    (Time.zone.now + hours.to_i.hours).to_i
  end

  # rubocop:disable Metrics
  def jwt_auth_validation
    if request.headers['Authentication'].present?
      @token_decoded = jwt_decode(request.headers['Authentication'])

      @user_id = @token_decoded['user_id']

      if @token_decoded['invalid'].present? && @token_decoded['invalid']
        return render json: {
          errors: I18n.t('activerecord.errors.jwt_methods.token.invalid')
        }, status: :unauthorized
      end

      if jwt_invalid_payload(@token_decoded)
        return render json: {
          errors: I18n.t('activerecord.errors.jwt_methods.token.payload.invalid')
        }, status: :unauthorized
      end

      if @token_decoded['exp'].present?
        time_start = Time.zone.at(@token_decoded['exp']) - 4.hours
        time_end = Time.zone.at(@token_decoded['exp'])
        time_now = Time.now.to_i

        if time_now >= time_start.to_i && time_now <= time_end.to_i
          @token_decoded['exp'] = jwt_time
          response.headers['jwt-token-renewed'] = jwt_encode(@token_decoded)
        end

        if time_now >= time_end.to_i
          render json: {
            errors: I18n.t('activerecord.errors.jwt_methods.token.expired')
          }, status: :unauthorized
        end
      end
    else
      render json: {
        errors: I18n.t('activerecord.errors.jwt_methods.token.missing')
      }, status: :unauthorized
    end
  end
  # rubocop:enable Metrics

  private

  def signing_token
    JOSE::JWK.from_oct(Rails.application.secrets.secret_key_base)
  end
end
