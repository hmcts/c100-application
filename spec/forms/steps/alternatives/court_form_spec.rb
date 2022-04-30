require 'spec_helper'

RSpec.describe Steps::Alternatives::CourtForm do
  let(:arguments) { {
    c100_application: c100_application,
    court_acknowledgement: court_acknowledgement
  } }
  let(:c100_application) { instance_double(C100Application, court_acknowledgement: nil) }
  let(:court_acknowledgement) { '1' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      it { should validate_presence_of(:court_acknowledgement) }
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          court_acknowledgement: true
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
