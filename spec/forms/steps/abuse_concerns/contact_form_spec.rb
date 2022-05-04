require 'spec_helper'

RSpec.describe Steps::AbuseConcerns::ContactForm do
  let(:arguments) { {
    c100_application: c100_application,
    concerns_contact_type: concerns_contact_type,
    concerns_contact_other: concerns_contact_other
  } }

  let(:c100_application) { instance_double(C100Application) }
  let(:concerns_contact_type)  { 'unsupervised' }
  let(:concerns_contact_other) { 'yes' }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(unsupervised supervised none))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :concerns_contact_type, example_value: 'unsupervised'

    it { should validate_presence_of(:concerns_contact_type,  :inclusion) }
    it { should validate_presence_of(:concerns_contact_other, :inclusion) }

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          concerns_contact_type: ConcernsContactType.new(:unsupervised),
          concerns_contact_other: GenericYesNo::YES,
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
