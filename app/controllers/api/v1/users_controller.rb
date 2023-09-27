module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, except: %i[create index]
      before_action :jwt_auth_validation, except: %i[index show]

      def index
        @users = User.all
      end

      def show; end

      def create
        @user = User.new(user_params)

        if @user.save
          render status: :created
        else
          render json: { errors: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          @user
        else
          render json: { errors: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def destroy
        @user if @user.destroy
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          errors: I18n.t('activerecord.errors.models.user.not_found')
        }, status: :not_found
      end

      def user_params
        params.permit(
          :name, :email, :password
        )
      end
    end
  end
end
