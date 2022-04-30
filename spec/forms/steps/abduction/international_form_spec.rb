require 'spec_helper'

RSpec.describe Steps::Abduction::InternationalForm do
  let(:arguments) { {
    c100_application: c100_application,
    passport_office_notified: 'yes',
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:passport_office_notified, :inclusion) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :abduction_detail,
                    expected_attributes: {
                      passport_office_notified: GenericYesNo::YES,
                    }
  end
end
