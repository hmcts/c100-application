require 'spec_helper'

RSpec.describe Steps::Abduction::PreviousAttemptForm do
  let(:arguments) { {
    c100_application: c100_application,
    previous_attempt: previous_attempt,
  } }

  let(:c100_application) { instance_double(C100Application) }
  let(:previous_attempt) { 'yes' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:previous_attempt, :inclusion) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :abduction_detail,
                    expected_attributes: {
                      previous_attempt: GenericYesNo::YES,
                    }

    context 'reset of other attributes' do
      let(:previous_attempt) { 'no' }

      it_behaves_like 'a has-one-association form',
                      association_name: :abduction_detail,
                      expected_attributes: {
                        previous_attempt: GenericYesNo::NO,
                        previous_attempt_details: nil,
                        previous_attempt_agency_involved: nil,
                        previous_attempt_agency_details: nil,
                      }
    end
  end
end
