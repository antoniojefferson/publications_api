require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:data_post) { create :post }

  subject { build :comment }

  context 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :comment }
    it { is_expected.to belong_to(:post) }
  end

  describe 'is valid' do
    context 'when all data is valid' do
      before do
        subject.name = FFaker::LoremBR.phrase
        subject.comment = FFaker::LoremBR.paragraph
        subject.post = data_post
      end

      it 'model is valid' do
        expect(subject).to be_valid
      end
    end
  end

  describe 'is invalid' do
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

    context 'when comment is not present' do
      before do
        subject.comment = ''
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:comment]).to include(message_blank)
      end
    end

    context 'when post is not present' do
      before do
        subject.post = nil
      end

      it 'model is invalid' do
        expect(subject).not_to be_valid
      end

      it 'returns error message for field' do
        subject.valid?
        expect(subject.errors.messages[:post]).to include(message_blank)
      end
    end
  end
end
