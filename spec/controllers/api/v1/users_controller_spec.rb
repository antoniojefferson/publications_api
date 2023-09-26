require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create :user }
  let!(:user_to_creating) { build :user, email: 'examples@gmail.com' }
  let!(:user_to_update) { build :user, id: user.id, email: 'corporate@gmail.com' }
  let(:result) do
    {
      id: user.id,
      name: user.name,
      email: user.email
    }.stringify_keys
  end
  let(:result_creation) do
    {
      name: user_to_creating.name,
      email: user_to_creating.email
    }.stringify_keys
  end
  let(:update_result) do
    {
      id: user.id,
      name: user_to_update.name,
      email: user_to_update.email
    }.stringify_keys
  end

  let(:result_exclusion) do
    {
      id: user.id
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
        get :show, format: :json, params: { id: user.id }
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
        expect(errors).to eq I18n.t('activerecord.errors.models.user.not_found')
      end
    end
  end

  describe 'POST #create' do
    let(:column_name) { I18n.t('activerecord.attributes.user.name') }
    let(:column_email) { I18n.t('activerecord.attributes.user.email') }
    let(:column_password) { I18n.t('activerecord.attributes.user.password_digest') }
    let(:email_invalid) { I18n.t('activerecord.errors.models.user.attributes.email.invalid') }
    let(:email_taken) { I18n.t('activerecord.errors.models.user.attributes.email.taken') }
    let(:password_invalid) { I18n.t('activerecord.errors.models.user.attributes.password_digest.too_short', count: 6) }
    let(:message_blank) { I18n.t('errors.messages.blank') }
    let(:errors_attribute) do
      [
        I18n.t('errors.format', attribute: column_password, message: message_blank),
        I18n.t('errors.format', attribute: column_password, message: password_invalid),
        I18n.t('errors.format', attribute: column_name, message: message_blank),
        I18n.t('errors.format', attribute: column_email, message: message_blank),
        I18n.t('errors.format', attribute: column_email, message: email_invalid),
        I18n.t('errors.format', attribute: column_email, message: email_taken)
      ].join(', ')
    end

    context 'when have data to save' do
      before do
        post :create, format: :json, params: user_to_creating.attributes
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
        post :create, params: { name: '', email: user.email, password: user.password_digest }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to include(message_blank)
      end
    end

    context 'when the email is empty' do
      before do
        post :create, params: { name: user.name, email: '', password: user.password_digest }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to include(message_blank)
      end
    end

    context 'when the password is empty' do
      before do
        post :create, params: { name: user.name, email: user.email, password: '' }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to include(message_blank)
      end
    end

    context 'when the password is too short' do
      before do
        post :create, params: { name: user.name, email: user.email, password: '35gmd' }
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(errors).to include(password_invalid)
      end
    end
  end

  describe 'PUT #update' do
    context 'when have data to update' do
      before do
        put :update, format: :json, params: user_to_update.attributes
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the data' do
        expect(json).to eq update_result
      end
    end

    context 'when not have data to update' do
      let(:column_name) { I18n.t('activerecord.attributes.user.name') }
      let(:column_email) { I18n.t('activerecord.attributes.user.email') }
      let(:email_invalid) { I18n.t('activerecord.errors.models.user.attributes.email.invalid') }
      let(:message_blank) { I18n.t('errors.messages.blank') }
      let(:errors_attribute) do
        [
          I18n.t('errors.format', attribute: column_name, message: message_blank),
          I18n.t('errors.format', attribute: column_email, message: message_blank),
          I18n.t('errors.format', attribute: column_email, message: email_invalid)
        ].join(', ')
      end

      before do
        put :update, params: { id: user.id, name: '', email: '' }
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
        delete :destroy, format: :json, params: { id: user.id }
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
        expect(errors).to eq I18n.t('activerecord.errors.models.user.not_found')
      end
    end
  end
end
