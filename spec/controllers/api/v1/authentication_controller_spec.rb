require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  let!(:user) { create :user, password: FFaker::Internet.password }

  describe 'POST #sign_in' do
    context 'with valid authentication params' do
      before do
        post :sign_in, format: :json, params: { email: user.email, password: user.password }
      end

      it 'returns a json with the keys JWT, user and status: created' do
        expect(json.keys).to contain_exactly('token', 'user')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid authentication params' do
      it 'returns a forbidden status and error message' do
        post :sign_in, params: { email: FFaker::Internet.email, password: FFaker::Internet.password }

        expect(response).to have_http_status(:forbidden)
        expect(errors).to eq(I18n.t('messages.errors.invalid'))
      end
    end
  end
end
