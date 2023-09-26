module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :jwt_auth_validation

      def sign_in
        @user = User.find_by(email: authentication_params[:email])
        if @user.present? && @user.authenticate(authentication_params[:password])
          payload = {
            user_id: @user.id, token_type: 'client_app2', exp: jwt_time
          }
          @jwt_token = jwt_encode(payload)
          render status: :created
        else
          render json: { errors: I18n.t('messages.errors.invalid') }, status: :forbidden
        end
      end

      private

      def authentication_params
        params.permit(:email, :password)
      end
    end
  end
end
