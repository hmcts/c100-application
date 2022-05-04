require 'spec_helper'

RSpec.describe Steps::Miam::CertificationDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    miam_certification_number: 'miam_certification_number',
    miam_certification_service_name: 'miam_certification_service_name',
    miam_certification_sole_trader_name: 'miam_certification_sole_trader_name',
  } }
  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    it { should validate_presence_of(:miam_certification_number) }
    it { should validate_presence_of(:miam_certification_service_name) }
    it { should_not validate_presence_of(:miam_certification_sole_trader_name) }

    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          miam_certification_number: 'miam_certification_number',
          miam_certification_service_name: 'miam_certification_service_name',
          miam_certification_sole_trader_name: 'miam_certification_sole_trader_name',
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
