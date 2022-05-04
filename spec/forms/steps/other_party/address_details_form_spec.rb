require 'spec_helper'

RSpec.describe Steps::OtherParty::AddressDetailsForm do
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
      address_unknown: address_unknown
    }
  end

  let(:c100_application) { instance_double(C100Application, other_parties: other_parties_collection) }
  let(:other_parties_collection) { double('other_parties_collection') }
  let(:party) { double('Party', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:address_unknown) { false }

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
        }
      }

      context 'when record does not exist' do
        let(:record) { nil }

        it 'creates the record if it does not exist' do
          expect(other_parties_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(party)

          expect(party).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:record) { party }

        it 'updates the record if it already exists' do
          expect(other_parties_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(party)

          expect(party).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end

        context 'when `address_unknown` is selected' do
          let(:address_unknown) { true }

          it 'resets previous address details, if any' do
            expect(other_parties_collection).to receive(:find_or_initialize_by).with(
              id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
            ).and_return(party)

            expect(party).to receive(:update).with(
              hash_including(address_data: {}, address_unknown: true)
            ).and_return(true)

            expect(subject.save).to be(true)
          end
        end
      end
    end
  end
end
