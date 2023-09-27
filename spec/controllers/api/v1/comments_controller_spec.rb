require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let!(:data_post) { create :post }
  let!(:comment) { create :comment }
  let!(:comment_to_creating) { build :comment, post: data_post, name: FFaker::LoremBR.phrase }
  let!(:comment_to_update) { build :comment, id: comment.id, post: data_post, name: FFaker::LoremBR.phrase }
  let(:result) do
    {
      id: comment.id,
      name: comment.name,
      comment: comment.comment
    }.stringify_keys
  end
  let(:result_creation) do
    {
      name: comment_to_creating.name,
      comment: comment_to_creating.comment
    }.stringify_keys
  end
  let(:update_result) do
    {
      id: comment.id,
      name: comment_to_update.name,
      comment: comment_to_update.comment
    }.stringify_keys
  end

  let(:result_exclusion) do
    {
      id: comment.id
    }.stringify_keys
  end

  describe 'GET #index' do
    context 'when have return data' do
      before do
        get :index, format: :json
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the data' do
        expect(json).to eq [result]
      end
    end
  end

  describe 'GET #show' do
    context 'when have return data' do
      before do
        get :show, format: :json, params: { id: comment.id }
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the data' do
        expect(json).to eq result
      end
    end

    context 'when not have return data' do
      before do
        get :show, format: :json, params: { id: 100 }
      end

      it 'returns not_found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('activerecord.errors.models.comment.not_found')
      end
    end
  end

  describe 'POST #create' do
    let(:column_name) { I18n.t('activerecord.attributes.comment.name') }
    let(:column_comment) { I18n.t('activerecord.attributes.comment.comment') }
    let(:column_post_id) { I18n.t('activerecord.attributes.comment.post_id') }
    let(:message_blank) { I18n.t('errors.messages.blank') }
    let(:errors_attribute) do
      [
        I18n.t('errors.format', attribute: column_name, message: message_blank),
        I18n.t('errors.format', attribute: column_comment, message: password_invalid),
        I18n.t('errors.format', attribute: column_user_id, message: message_blank)
      ].join(', ')
    end

    context 'when have data to save' do
      before do
        post :create, format: :json, params: comment_to_creating.attributes
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the data' do
        expect(json).to eq result_creation
      end
    end

    context 'when the name is empty' do
      before do
        post :create, params: { name: '', comment: comment.comment, post_id: data_post.id }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('errors.format', attribute: column_name, message: message_blank)
      end
    end

    context 'when the comment is empty' do
      before do
        post :create, params: { name: comment.name, comment: '', post_id: data_post.id }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('errors.format', attribute: column_comment, message: message_blank)
      end
    end

    context 'when the post_id is empty' do
      before do
        post :create, params: { name: comment.name, comment: comment.comment, post_id: nil }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('errors.format', attribute: column_post_id, message: message_blank)
      end
    end
  end

  describe 'PUT #update' do
    context 'when have data to update' do
      before do
        put :update, format: :json, params: comment_to_update.attributes
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the data' do
        expect(json).to eq update_result
      end
    end

    context 'when not have data to update' do
      let(:column_name) { I18n.t('activerecord.attributes.comment.name') }
      let(:column_comment) { I18n.t('activerecord.attributes.comment.comment') }
      let(:column_post_id) { I18n.t('activerecord.attributes.comment.post_id') }
      let(:message_blank) { I18n.t('errors.messages.blank') }
      let(:errors_attribute) do
        [
          I18n.t('errors.format', attribute: column_post_id, message: message_blank),
          I18n.t('errors.format', attribute: column_name, message: message_blank),
          I18n.t('errors.format', attribute: column_comment, message: message_blank)
        ].join(', ')
      end

      before do
        put :update, params: { id: comment.id, name: nil, comment: nil, post_id: nil }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to eq errors_attribute
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when have data to delete' do
      before do
        delete :destroy, format: :json, params: { id: comment.id }
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the data' do
        expect(json).to eq result_exclusion
      end
    end

    context 'when not have data to delete' do
      before do
        delete :destroy, params: { id: 100 }
      end

      it 'returns not_found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('activerecord.errors.models.comment.not_found')
      end
    end
  end
end
