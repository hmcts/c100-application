require 'spec_helper'

RSpec.describe Steps::Respondent::AddressDetailsForm do
  let(:arguments) do
    {
      c100_application: c100_application,
      record: record,
      address_line_1: address_line_1,
      address_line_2: address_line_2,
      address_line_3: address_line_3,
      town: town,
      country: country,
      postcode: postcode,
      address_unknown: address_unknown,
      residence_requirement_met: residence_requirement_met,
      residence_history: residence_history,
      residence_history_no: residence_history_no,
      residence_history_unknown: residence_history_unknown
    }
  end
  let(:c100_application) { instance_double(C100Application, respondents: respondents_collection) }
  let(:respondents_collection) { double('respondents_collection') }
  let(:respondent) { double('Respondent', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe9') }

  let(:record) { nil }
  let(:address_unknown) { false }
  let(:residence_requirement_met) { 'no' }
  let(:residence_history) { 'history' }
  let(:residence_history_no) { 'history' }
  let(:residence_history_unknown) { 'history' }

  let(:address_line_1) { 'address_line_1' }
  let(:address_line_2) { 'address_line_2' }
  let(:address_line_3) { 'address_line_3' }
  let(:town) { 'town' }
  let(:country) { 'country' }
  let(:postcode) { 'postcode' }

  subject { described_class.new(arguments) }

  describe '#residence_history_no' do
    context 'returns initialized value' do
      let(:residence_history_no) { 'yesterday' }
      let(:residence_history) { nil }

      specify { expect(subject.residence_history_no).to eq(residence_history_no) }
    end

    context 'returns residence_history value' do
      let(:residence_history_no) { nil }
      let(:residence_requirement_met) { 'no' }

      specify { expect(subject.residence_history_no).to eq(residence_history) }
    end

    context 'returns nil' do
      let(:residence_history_no) { nil }
      let(:residence_requirement_met) { 'yes' }

      specify { expect(subject.residence_history_no).to be_blank }
    end
  end

  describe '#residence_history_unknown' do
    context 'returns initialized value' do
      let(:residence_history_unknown) { 'yesterday' }
      let(:residence_history) { nil }

      specify { expect(subject.residence_history_unknown).to eq(residence_history_unknown) }
    end

    context 'returns residence_history value' do
      let(:residence_history_unknown) { nil }
      let(:residence_requirement_met) { 'unknown' }

      specify { expect(subject.residence_history_unknown).to eq(residence_history) }
    end

    context 'returns nil' do
      let(:residence_history_unknown) { nil }
      let(:residence_requirement_met) { 'yes' }

      specify { expect(subject.residence_history_unknown).to be_blank }
    end
  end

  describe '#residence_history_value' do
    context 'when residence_requirement_met is yes' do
      let(:residence_requirement_met) { 'yes' }

      specify { expect(subject.residence_history_value).to be_blank }
    end

    context 'when residence_requirement_met is no' do
      let(:residence_requirement_met) { 'no' }

      specify { expect(subject.residence_history_value).to eq(residence_history_no) }
    end

    context 'when residence_requirement_met is unknown' do
      let(:residence_requirement_met) { 'unknown' }

      specify { expect(subject.residence_history_value).to eq(residence_history_unknown) }
    end
  end

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

      context 'when attribute is `no`, does not require residency history' do
        let(:residence_requirement_met) { 'no' }
        let(:residence_history) { nil }

        it 'has no validation errors' do
          expect(subject).to be_valid
        end
      end

      context 'when attribute is `unknown`, does not require residency history' do
        let(:residence_requirement_met) { 'unknown' }
        let(:residence_history) { nil }

        it 'has no validation errors' do
          expect(subject).to be_valid
        end
      end
    end

    context 'validations on field presence when `address_unknown` is false' do
      it { should validate_presence_of(:address_line_1) }
      it { should validate_presence_of(:town) }

      it { should_not validate_presence_of(:address_line_2) }
      it { should_not validate_presence_of(:address_line_3) }
      it { should_not validate_presence_of(:country) }
      it { should_not validate_presence_of(:postcode) }
    end

    context 'validations on field presence when `address_unknown` is true' do
      let(:address_unknown) { true }

      it { should_not validate_presence_of(:address_line_1) }
      it { should_not validate_presence_of(:address_line_2) }
      it { should_not validate_presence_of(:address_line_3) }
      it { should_not validate_presence_of(:town) }
      it { should_not validate_presence_of(:country) }
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
          residence_requirement_met: GenericYesNoUnknown::NO,
          residence_history: 'history'
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
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe9'
          ).and_return(respondent)

          expect(respondent).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end

        context 'when `address_unknown` is selected' do
          let(:address_unknown) { true }

          it 'resets previous address details, if any' do
            expect(respondents_collection).to receive(:find_or_initialize_by).with(
              id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe9'
            ).and_return(respondent)

            expect(respondent).to receive(:update).with(
              hash_including(address_data: {}, address_unknown: true)
            ).and_return(true)

            expect(subject.save).to be(true)
          end
        end
      end
    end
  end
end
