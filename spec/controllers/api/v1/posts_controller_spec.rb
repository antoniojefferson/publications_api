require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let!(:user) { create :user }
  let!(:data_post) { create :post }
  let!(:comment) { create :comment, post: data_post }
  let!(:post_to_creating) { build :post, user: user, title: FFaker::LoremBR.phrase }
  let!(:post_to_update) { build :post, id: data_post.id, user: user, title: FFaker::LoremBR.phrase }
  let(:token) { custom_sign_in user }
  let(:result) do
    {
      id: data_post.id,
      title: data_post.title,
      text: data_post.text,
      comments: data_post.comments.map { |post| { id: post.id, name: post.name, comment: post.comment }.stringify_keys }
    }.stringify_keys
  end
  let(:result_creation) do
    {
      title: post_to_creating.title,
      text: post_to_creating.text
    }.stringify_keys
  end
  let(:update_result) do
    {
      id: data_post.id,
      title: post_to_update.title,
      text: post_to_update.text
    }.stringify_keys
  end

  let(:result_exclusion) do
    {
      id: data_post.id
    }.stringify_keys
  end

  describe 'GET #index' do
    context 'when have return data' do
      before do
        include_authenticated_header(token)
        get :index, format: :json
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the data' do
        expect(json).to eq [result]
      end
    end

    context 'when there is no authentication' do
      before do
        get :index, format: :json
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the data' do
        expect(errors).to eq I18n.t('activerecord.errors.jwt_methods.token.missing')
      end
    end
  end

  describe 'GET #show' do
    context 'when have return data' do
      before do
        include_authenticated_header(token)
        get :show, format: :json, params: { id: data_post.id }
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
        include_authenticated_header(token)
        get :show, format: :json, params: { id: 100 }
      end

      it 'returns not_found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('activerecord.errors.models.post.not_found')
      end
    end

    context 'when there is no authentication' do
      before do
        get :show, format: :json, params: { id: data_post.id }
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the data' do
        expect(errors).to eq I18n.t('activerecord.errors.jwt_methods.token.missing')
      end
    end
  end

  describe 'POST #create' do
    let(:column_title) { I18n.t('activerecord.attributes.post.title') }
    let(:column_text) { I18n.t('activerecord.attributes.post.text') }
    let(:column_user_id) { I18n.t('activerecord.attributes.post.user_id') }
    let(:message_blank) { I18n.t('errors.messages.blank') }
    let(:errors_attribute) do
      [
        I18n.t('errors.format', attribute: column_title, message: message_blank),
        I18n.t('errors.format', attribute: column_text, message: password_invalid),
        I18n.t('errors.format', attribute: column_user_id, message: message_blank)
      ].join(', ')
    end

    context 'when have data to save' do
      before do
        include_authenticated_header(token)
        post :create, format: :json, params: post_to_creating.attributes
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the data' do
        expect(json).to eq result_creation
      end
    end

    context 'when the title is empty' do
      before do
        include_authenticated_header(token)
        post :create, params: { title: '', text: data_post.text, user_id: user.id }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('errors.format', attribute: column_title, message: message_blank)
      end
    end

    context 'when the text is empty' do
      before do
        include_authenticated_header(token)
        post :create, params: { title: data_post.title, text: '', user_id: user.id }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('errors.format', attribute: column_text, message: message_blank)
      end
    end

    context 'when the user_id is empty' do
      before do
        include_authenticated_header(token)
        post :create, params: { title: data_post.title, text: data_post.text, user_id: nil }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('errors.format', attribute: column_user_id, message: message_blank)
      end
    end

    context 'when there is no authentication' do
      before do
        post :create, format: :json, params: post_to_creating.attributes
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the data' do
        expect(errors).to eq I18n.t('activerecord.errors.jwt_methods.token.missing')
      end
    end
  end

  describe 'PUT #update' do
    context 'when have data to update' do
      before do
        include_authenticated_header(token)
        put :update, format: :json, params: post_to_update.attributes
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the data' do
        expect(json).to eq update_result
      end
    end

    context 'when not have user_id to update' do
      let(:column_title) { I18n.t('activerecord.attributes.post.title') }
      let(:column_text) { I18n.t('activerecord.attributes.post.text') }
      let(:column_user_id) { I18n.t('activerecord.attributes.post.user_id') }
      let(:message_blank) { I18n.t('errors.messages.blank') }
      let(:errors_attribute) do
        [
          I18n.t('errors.format', attribute: column_user_id, message: message_blank)
        ].join(', ')
      end

      before do
        include_authenticated_header(token)
        put :update, params: { id: data_post.id, user_id: '' }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to eq errors_attribute
      end
    end

    context 'when there is no authentication' do
      before do
        put :update, format: :json, params: post_to_update.attributes
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the data' do
        expect(errors).to eq I18n.t('activerecord.errors.jwt_methods.token.missing')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when have data to delete' do
      before do
        include_authenticated_header(token)
        delete :destroy, format: :json, params: { id: data_post.id }
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
        include_authenticated_header(token)
        delete :destroy, params: { id: 100 }
      end

      it 'returns not_found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(errors).to eq I18n.t('activerecord.errors.models.post.not_found')
      end
    end

    context 'when there is no authentication' do
      before do
        delete :destroy, format: :json, params: { id: data_post.id }
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the data' do
        expect(errors).to eq I18n.t('activerecord.errors.jwt_methods.token.missing')
      end
    end
  end
end
