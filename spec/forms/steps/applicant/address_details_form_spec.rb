require 'spec_helper'

RSpec.describe Steps::Applicant::AddressDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    address_line_1: address_line_1,
    address_line_2: address_line_2,
    address_line_3: address_line_3,
    town: town,
    country: country,
    postcode: postcode,
    residence_requirement_met: residence_requirement_met,
    residence_history: residence_history,
    residence_keep_private: residence_keep_private
  } }

  let(:c100_application) { instance_double(C100Application, applicants: applicants_collection, address_confidentiality: address_confidentiality) }
  let(:applicants_collection) { double('applicants_collection') }
  let(:applicant) { double('Applicant', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe9') }

  let(:record) { nil }
  let(:residence_requirement_met) { 'no' }
  let(:residence_keep_private) { 'yes' }
  let(:residence_history) { 'history' }
  let(:address_confidentiality) { 'no' }

  let(:address_line_1) { 'address_line_1' }
  let(:address_line_2) { 'address_line_2' }
  let(:address_line_3) { 'address_line_3' }
  let(:town) { 'town' }
  let(:country) { 'country' }
  let(:postcode) { 'postcode' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'residence_requirement_met' do
      context 'when attribute is not given' do
        let(:residence_requirement_met) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:residence_requirement_met]).to_not be_empty
        end
      end

      context 'when attribute is given and requires residency history' do
        let(:residence_requirement_met) { 'no' }
        let(:residence_history) { nil }

        it 'has a validation error on the `residence_history` field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:residence_history]).to_not be_empty
        end
      end

      context 'when attribute is given and does not requires residency history' do
        let(:residence_requirement_met) { 'yes' }
        let(:residence_history) { nil }

        it 'has no validation errors' do
          expect(subject).to be_valid
        end
      end
    end

    context 'residence_keep_private' do
      let(:residence_requirement_met) { 'yes' }
      context 'when attribute is not given and address_confidentiality is true' do
        let(:residence_keep_private) { nil }
        let(:address_confidentiality) { 'yes' }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:residence_keep_private]).to_not be_empty
        end
      end

      context 'when attribute is not given and address_confidentiality is false' do
        let(:residence_keep_private) { nil }
        let(:address_confidentiality) { 'no' }

        it 'returns true' do
          allow(applicants_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(applicant)
          allow(applicant).to receive(:update).and_return(true)


          expect(subject.save).to be(true)
        end

        it 'has a validation error on the field' do
          expect(subject).to be_valid
          expect(subject.errors[:residence_keep_private]).to be_empty
        end
      end

    end

    context 'field presence validations' do
      it { should validate_presence_of(:address_line_1) }
      it { should validate_presence_of(:town) }
      it { should validate_presence_of(:country) }

      it { should_not validate_presence_of(:address_line_2) }
      it { should_not validate_presence_of(:postcode) }
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          address_data: {
            address_line_1: 'address_line_1',
            address_line_2: 'address_line_2',
            address_line_3: 'address_line_3',
            town: 'town',
            country: 'country',
            postcode: 'postcode'
          },
          address_unknown: false,
          residence_requirement_met: GenericYesNo::NO,
          residence_history: 'history',
          residence_keep_private: GenericYesNo::YES
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
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe9'
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
