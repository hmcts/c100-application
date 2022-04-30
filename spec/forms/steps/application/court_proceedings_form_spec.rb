require 'spec_helper'

RSpec.describe Steps::Application::CourtProceedingsForm do
  let(:arguments) { {
    c100_application: c100_application,
    children_names: 'children_names',
    court_name: 'court_name',
    case_number: 'case_number',
    proceedings_date: 'proceedings_date',
    cafcass_details: 'cafcass_details',
    order_types: 'order_types',
    previous_details: 'previous_details',
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:children_names) }
      it { should validate_presence_of(:court_name) }
      it { should validate_presence_of(:order_types) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :court_proceeding,
                    expected_attributes: {
                      children_names: 'children_names',
                      court_name: 'court_name',
                      case_number: 'case_number',
                      proceedings_date: 'proceedings_date',
                      cafcass_details: 'cafcass_details',
                      order_types: 'order_types',
                      previous_details: 'previous_details',
                    }
  end
end
