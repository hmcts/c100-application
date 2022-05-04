require 'spec_helper'

RSpec.describe Steps::Address::ResultsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    selected_address: selected_address,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:record) { nil }
  let(:selected_address) { 'address_line_1|address_line_2|address_line_3|town|country|postcode' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when the attribute is not given' do
      let(:selected_address) { nil }

      it 'adds a `blank` error on the attribute' do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:selected_address, :blank)).to eq(true)
      end
    end

    context 'when the attribute is an empty string' do
      let(:selected_address) { '' }

      it 'adds a `blank` error on the attribute' do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:selected_address, :blank)).to eq(true)
      end
    end

    context 'for valid details' do
      let(:record) { spy(Applicant) }

      it 'updates the record' do
        expect(record).to receive(:update).with(
          address_line_1: 'address_line_1',
          address_line_2: 'address_line_2',
          address_line_3: 'address_line_3',
          town: 'town',
          country: 'country',
          postcode: 'postcode'
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
