require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create :user }

  subject { build :post }

  context 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :text }
    it { is_expected.to belong_to(:user) }
  end

  describe 'is valid' do
    context 'when all data is valid' do
      before do
        subject.title = FFaker::LoremBR.phrase
        subject.text = FFaker::LoremBR.paragraph
        subject.user = user
      end

      it 'model is valid' do
        expect(subject).to be_valid
      end
    end
  end

  describe 'is invalid' do
    let(:message_blank) { I18n.t('errors.messages.blank') }

    context 'when title is not present' do
      before do
        subject.title = ''
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:title]).to include(message_blank)
      end
    end

    context 'when text is not present' do
      before do
        subject.text = ''
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:text]).to include(message_blank)
      end
    end

    context 'when user is not present' do
      before do
        subject.user = nil
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:user]).to include(message_blank)
      end
    end
  end
end
