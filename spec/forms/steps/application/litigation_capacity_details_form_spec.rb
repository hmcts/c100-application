require 'spec_helper'

RSpec.describe Steps::Application::LitigationCapacityDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    participation_capacity_details: participation_capacity_details,
    participation_referral_or_assessment_details: participation_referral_or_assessment_details,
    participation_other_factors_details: participation_other_factors_details
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:participation_capacity_details) { 'details' }
  let(:participation_referral_or_assessment_details) { nil }
  let(:participation_other_factors_details) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          participation_capacity_details: 'details',
          participation_referral_or_assessment_details: nil,
          participation_other_factors_details: nil
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
