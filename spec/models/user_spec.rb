require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build :user, email: 'examples@gmail.com' }

  context 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password_digest }
    it { is_expected.to validate_uniqueness_of :email }
  end

  describe 'is valid' do
    context 'when all data is valid' do
      before do
        subject.name = 'Sophia'
        subject.email = 'sophia@gmail.com'
        subject.password_digest = 'Temp@123'
      end

      it 'model is valid' do
        expect(subject).to be_valid
      end
    end
  end

  describe 'is invalid' do
    let(:email_taken) { I18n.t('activerecord.errors.models.user.attributes.email.taken') }
    let(:email_invalid) { I18n.t('activerecord.errors.models.user.attributes.email.invalid') }
    let(:password_invalid) { I18n.t('activerecord.errors.models.user.attributes.password_digest.too_short', count: 6) }
    let(:message_blank) { I18n.t('errors.messages.blank') }

    context 'when name is not present' do
      before do
        subject.name = ''
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:name]).to include(message_blank)
      end
    end

    context 'when email is not present' do
      before do
        subject.email = ''
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:email]).to include(message_blank)
      end
    end

    context 'when the email format is not valid' do
      before do
        subject.email = 'examplesgmail.com'
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:email]).to include(email_invalid)
      end
    end

    context 'when the email is duplicated' do
      let!(:user_new) { create :user, email: 'examples@gmail.com' }

      before do
        subject.email = 'examples@gmail.com'
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:email]).to include(email_taken)
      end
    end

    context 'when the password is not present' do
      before do
        subject.password_digest = ''
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:password_digest]).to include(message_blank)
      end
    end

    context 'when the password is not the minimum length' do
      before do
        subject.password_digest = 'temp@'
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:password_digest]).to include(password_invalid)
      end
    end
  end
end
