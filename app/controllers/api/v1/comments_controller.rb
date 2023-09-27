module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_comment, except: %i[create index]

      def index
        @comments = Comment.all
      end

      def show; end

      def create
        @comment = Comment.new(comment_params)
        if @comment.save
          render status: :created
        else
          render json: { errors: @comment.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def update
        if @comment.update(comment_params)
          @comment
        else
          render json: { errors: @comment.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def destroy
        @comment if @comment.destroy
      end

      private

      def set_comment
        @comment = Comment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          errors: I18n.t('activerecord.errors.models.comment.not_found')
        }, status: :not_found
      end

      def comment_params
        params.permit(
          :name, :comment, :post_id
        )
      end
    end
  end
end
