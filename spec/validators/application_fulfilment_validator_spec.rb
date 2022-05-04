require 'rails_helper'

module Test
  C100ApplicationValidatable = Struct.new(:children, :applicants, :respondents, :payment_type, :submission_type, keyword_init: true) do
    include ActiveModel::Validations
    validates_with ApplicationFulfilmentValidator
  end
end

RSpec.describe ApplicationFulfilmentValidator, type: :model do
  subject { Test::C100ApplicationValidatable.new(arguments) }

  let(:arguments) do
    {
      children: children,
      applicants: applicants,
      respondents: respondents,
      payment_type: payment_type,
      submission_type: submission_type,
    }
  end

  let(:children)    { [Object] }
  let(:applicants)  { [Object] }
  let(:respondents) { [Object] }

  let(:submission_type) { 'submission_type' }
  let(:payment_type)    { 'payment_type' }

  context 'individual validations' do
    context 'payment_type' do
      context 'when there is a payment type' do
        it 'is valid' do
          subject.valid?
          expect(subject.errors.details.include?(:payment_type)).to eq(false)
        end
      end

      context 'when payment type is missing' do
        let(:payment_type) { nil }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors.details[:payment_type][0][:error]).to eq(:blank)
          expect(subject.errors.details[:payment_type][0][:change_path]).to eq('/steps/application/payment')
        end
      end
    end

    context 'submission_type' do
      context 'when there is a submission type' do
        it 'is valid' do
          subject.valid?
          expect(subject.errors.details.include?(:submission_type)).to eq(false)
        end
      end

      context 'when submission type is missing' do
        let(:submission_type) { nil }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors.details[:submission_type][0][:error]).to eq(:blank)
          expect(subject.errors.details[:submission_type][0][:change_path]).to eq('/steps/application/submission')
        end
      end
    end

    context 'children' do
      context 'there is at least one child' do
        it 'is valid' do
          subject.valid?
          expect(subject.errors.details.include?(:children)).to eq(false)
        end
      end

      context 'there are no children' do
        let(:children) { [] }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors.details[:children][0][:error]).to eq(:blank)
          expect(subject.errors.details[:children][0][:change_path]).to eq('/steps/children/names/')
        end
      end
    end

    context 'applicants' do
      context 'there is at least one applicant' do
        it 'is valid' do
          subject.valid?
          expect(subject.errors.details.include?(:applicants)).to eq(false)
        end
      end

      context 'there are no applicants' do
        let(:applicants) { [] }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors.details[:applicants][0][:error]).to eq(:blank)
          expect(subject.errors.details[:applicants][0][:change_path]).to eq('/steps/applicant/names/')
        end
      end
    end

    context 'respondents' do
      context 'there is at least one respondent' do
        it 'is valid' do
          subject.valid?
          expect(subject.errors.details.include?(:respondents)).to eq(false)
        end
      end

      context 'there are no respondents' do
        let(:respondents) { [] }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors.details[:respondents][0][:error]).to eq(:blank)
          expect(subject.errors.details[:respondents][0][:change_path]).to eq('/steps/respondent/names/')
        end
      end
    end
  end
end
