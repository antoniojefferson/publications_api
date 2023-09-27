module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, except: %i[create index]

      def index
        @posts = Post.all
      end

      def show; end

      def create
        @post = Post.new(post_params)
        if @post.save
          render status: :created
        else
          render json: { errors: @post.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def update
        if @post.update(post_params)
          @post
        else
          render json: { errors: @post.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def destroy
        @post if @post.destroy
      end

      private

      def set_post
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          errors: I18n.t('activerecord.errors.models.post.not_found')
        }, status: :not_found
      end

      def post_params
        params.permit(
          :title, :text, :user_id
        )
      end
    end
  end
end
