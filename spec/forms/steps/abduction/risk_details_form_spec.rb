require 'spec_helper'

RSpec.describe Steps::Abduction::RiskDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    risk_details: 'details',
    current_location: 'Spain'
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:risk_details) }
      it { should validate_presence_of(:current_location) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :abduction_detail,
                    expected_attributes: {
                      risk_details: 'details',
                      current_location: 'Spain'
                    }
  end
end
