require 'spec_helper'

RSpec.describe Steps::Applicant::ContactDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    home_phone: home_phone,
    mobile_phone: mobile_phone,
    email: email,
    voicemail_consent: voicemail_consent,
    email_provided: email_provided,
    email_keep_private: email_keep_private,
    mobile_keep_private: mobile_keep_private,
    phone_keep_private: phone_keep_private
  } }

  let(:c100_application) { instance_double(C100Application, applicants: applicants_collection, address_confidentiality: address_confidentiality) }
  let(:applicants_collection) { double('applicants_collection') }
  let(:applicant) { double('Applicant', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }
  let(:address_confidentiality) { 'no' }

  let(:record) { nil }
  let(:home_phone) { nil }
  let(:mobile_phone) { '12345' }
  let(:email) { 'test@example.com' }
  let(:voicemail_consent) { 'yes' }
  let(:email_provided) { 'yes' }
  let(:email_keep_private) { nil }
  let(:mobile_keep_private) { nil }
  let(:phone_keep_private) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'mobile phone presence' do
      let(:mobile_phone) { nil }

      it 'has a validation error on the field if not present' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:mobile_phone, :blank)).to eq(true)
      end
    end

    context 'mobile phone validation' do
      let(:mobile_phone) { '3123 abc' }

      it 'has a validation error on the field if not present' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:mobile_phone, :invalid)).to eq(true)
      end
    end

    context 'when no email provided' do
      let(:email_provided) { 'no' }
      let(:email_keep_private) { 'yes' }

      it '#attributes_map resets email' do
        expect(subject.send(:attributes_map)).to include(email: nil)
      end

      it '#attributes_map resets email' do
        expect(subject.send(:attributes_map)).to include(email_keep_private: nil)
      end
    end

    describe 'email validation' do
      context 'when email not provided' do
        let(:email) { nil }
        let(:email_provided) { 'no' }
        before { subject.valid? }
        specify { expect(subject).to be_valid }
      end

      context 'when email provided' do
        let(:email) { nil }
        let(:email_provided) { 'yes' }
        before { subject.valid? }
        specify { expect(subject).to_not be_valid }
        specify { expect(subject.errors.details.dig(:email, 0, :error)).to eq(:invalid) }
      end

      %w(bad bad@ bad@domain bad@domain.).each do |malformed_email|
        context "when email set to '#{malformed_email}'" do
          let(:email) { malformed_email }
          before { subject.valid? }
          specify { expect(subject).to_not be_valid }
          specify { expect(subject.errors.details.dig(:email, 0, :error)).to eq(:invalid) }
        end
      end
    end

    context 'voicemail consent validation' do
      context 'when attribute is not given' do
        let(:voicemail_consent) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:voicemail_consent]).to_not be_empty
        end
      end

      context 'when attribute value is not valid' do
        let(:voicemail_consent) {'INVALID VALUE'}

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:voicemail_consent]).to_not be_empty
        end
      end
    end

    context 'keep private validation' do
      let(:address_confidentiality) { 'yes' }
      let(:phone_keep_private) { GenericYesNo::YES }
      let(:email_keep_private) { GenericYesNo::YES }
      let(:mobile_keep_private) { GenericYesNo::YES }

      before { subject.valid? }

      describe 'email' do
        context 'provided' do
          let(:email) { 'test@example.com' }
          let(:email_provided) { 'yes' }
          let(:email_keep_private) { nil }

          specify { expect(subject).not_to be_valid }
        end

        context 'not provided' do
          let(:email) { nil }
          let(:email_provided) { 'no' }
          let(:email_keep_private) { nil }

          specify { expect(subject).to be_valid }
        end
      end

      describe 'phone' do
        context 'provided' do
          let(:home_phone) { 123456889 }
          let(:phone_keep_private) { nil }

          specify { expect(subject).not_to be_valid }
        end

        context 'not provided' do
          let(:home_phone) { nil }
          let(:phone_keep_private) { nil }

          specify { expect(subject).to be_valid }
        end

      end

      describe 'mobile' do
        context 'provided' do
          let(:mobile_phone) { 123456889 }
          let(:mobile_keep_private) { nil }

          specify { expect(subject).not_to be_valid }
        end
      end
    end



    context 'for valid details' do
      let(:expected_attributes) {
        {
          email: 'test@example.com',
          home_phone: '',
          mobile_phone: '12345',
          voicemail_consent: GenericYesNo::YES,
          email_provided: GenericYesNo::YES,
          email_keep_private: nil,
          phone_keep_private: nil,
          mobile_keep_private: nil,
        }
      }

      context 'when record does not exist' do
        let(:record) { nil }

        it 'creates the record if it does not exist' do
          expect(applicants_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(applicant)

          expect(applicant).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:record) { applicant }

        it 'updates the record if it already exists' do
          expect(applicants_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(applicant)

          expect(applicant).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
