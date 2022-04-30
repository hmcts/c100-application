require 'spec_helper'

RSpec.describe Steps::Respondent::ContactDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    home_phone: home_phone,
    home_phone_unknown: home_phone_unknown,
    mobile_phone: mobile_phone,
    mobile_phone_unknown: mobile_phone_unknown,
    email: email,
    email_unknown: email_unknown
  } }

  let(:c100_application) { instance_double(C100Application, respondents: respondents_collection) }
  let(:respondents_collection) { double('respondents_collection') }
  let(:respondent) { double('Respondent', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:home_phone) { '07777777777' }
  let(:home_phone_unknown) { nil }
  let(:mobile_phone) { '07777777777' }
  let(:mobile_phone_unknown) { nil }
  let(:email_unknown) { nil }
  let(:email) { 'test@test.com' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'email validation' do

      context 'accepts a valid email' do
        let(:email) { 'name@example.com' }
        let(:email_unknown) { false }
        it { expect(subject).to be_valid }
      end

      context 'email can be not known' do
        let(:email) { nil }
        let(:email_unknown) { true }
        it { expect(subject).to be_valid }
      end

      context 'email must be either present or not known' do
        let(:email) { nil }
        let(:email_unknown) { false }
        it { expect(subject).not_to be_valid }
      end

      context 'email is validated if present' do
        let(:email) { 'xxx' }
        it {
          expect(subject).not_to be_valid
          expect(subject.errors[:email]).to_not be_empty
        }
      end
    end

    context 'phone validation' do      
      [:home_phone, :mobile_phone].each do |phone_type|
        context "with #{phone_type}" do
          context 'number is present is valid' do
            let(phone_type) { '07777777777' }
            it { expect(subject).to be_valid }
          end

          context 'invalid number is invalid' do
            let(phone_type) { '07777abc777777' }
            it { expect(subject).not_to be_valid }
          end

          context 'number is unknown is valid' do
            let(phone_type) { nil }
            let( "#{phone_type}_unknown".to_sym) { true }
            it { expect(subject).to be_valid }
          end

          context 'no input from user is invalid' do
            let(phone_type) { nil }
            let( "#{phone_type}_unknown".to_sym) { false }
            it {
              expect(subject).not_to be_valid
              expect(subject.errors[phone_type]).to_not be_empty
            }
          end
        end
      end
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          email: 'test@test.com',
          home_phone: '07777777777',
          mobile_phone: '07777777777',
          home_phone_unknown: nil,
          mobile_phone_unknown: nil,
          email_unknown: nil
        }
      }

      context 'when record does not exist' do
        let(:record) { nil }

        it 'creates the record if it does not exist' do
          expect(respondents_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(respondent)

          expect(respondent).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:record) { respondent }

        it 'updates the record if it already exists' do
          expect(respondents_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(respondent)

          expect(respondent).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
