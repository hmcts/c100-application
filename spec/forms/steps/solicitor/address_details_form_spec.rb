require 'spec_helper'

RSpec.describe Steps::Solicitor::AddressDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    address_line_1: 'address_line_1',
    address_line_2: 'address_line_2',
    address_line_3: 'address_line_3',
    town: 'town',
    country: 'country',
    postcode: 'postcode',
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:address_line_1) }
      it { should_not validate_presence_of(:address_line_2) }
      it { should_not validate_presence_of(:address_line_3) }

      it { should validate_presence_of(:town) }
      it { should validate_presence_of(:country) }
      it { should validate_presence_of(:postcode) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :solicitor,
                    expected_attributes: {
                      address_data: {
                        address_line_1: 'address_line_1',
                        address_line_2: 'address_line_2',
                        address_line_3: 'address_line_3',
                        town: 'town',
                        country: 'country',
                        postcode: 'postcode',
                      }
                    }
  end
end
