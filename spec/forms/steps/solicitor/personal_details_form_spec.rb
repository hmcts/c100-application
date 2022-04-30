require 'spec_helper'

RSpec.describe Steps::Solicitor::PersonalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    full_name: 'full_name',
    firm_name: 'firm_name',
    reference: 'reference',
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:full_name) }
      it { should validate_presence_of(:firm_name) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :solicitor,
                    expected_attributes: {
                      full_name: 'full_name',
                      firm_name: 'firm_name',
                      reference: 'reference',
                    }
  end
end
