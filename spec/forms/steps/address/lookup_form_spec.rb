require 'spec_helper'

RSpec.describe Steps::Address::LookupForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    postcode: postcode,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:record) { nil }
  let(:postcode) { 'SW1H 9AJ' }

  subject { described_class.new(arguments) }

  describe '#to_partial_path' do
    let(:path) { subject.to_partial_path }

    context 'for an `Applicant` record' do
      let(:record) { Applicant.new }
      it { expect(path).to eq('steps/address/lookup/applicant') }
    end

    context 'for a `Respondent` record' do
      let(:record) { Respondent.new }
      it { expect(path).to eq('steps/address/lookup/respondent') }
    end

    context 'for an `OtherParty` record' do
      let(:record) { OtherParty.new }
      it { expect(path).to eq('steps/address/lookup/other_party') }
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when the attribute is not given' do
      let(:postcode) { nil }

      it 'adds a `blank` error on the attribute' do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:postcode, :blank)).to eq(true)
      end
    end

    context 'when the attribute is given but is not a valid postcode' do
      let(:postcode) { 'SE1' }

      it 'adds an `invalid` error on the attribute' do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:postcode, :invalid)).to eq(true)
      end
    end

    context 'for valid details' do
      before do
        allow(postcode).to receive(:eql?).and_call_original
      end

      context 'when the postcode has changed' do
        let(:record) { spy(Applicant, postcode: nil) }

        it 'updates the record' do
          expect(record).to receive(:update).with(
            postcode: 'SW1H 9AJ',
            country: 'UNITED KINGDOM',
            address_line_1: nil,
            address_line_2: nil,
            town: nil,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when the postcode is the same as in the persisted record' do
        let(:record) { spy(Applicant, postcode: postcode) }

        it 'does not save the record but returns true' do
          expect(record).not_to receive(:update)
          expect(subject.save).to be(true)

          # mutant kill
          expect(postcode).to have_received(:eql?).with('SW1H 9AJ')
        end
      end
    end
  end
end
