require 'spec_helper'

RSpec.describe Steps::Petition::OrdersForm do
  let(:arguments) { {
    c100_application: c100_application,
    child_arrangements_home: '1',
    specific_issues_school: '0',
    specific_issues_medical: '1',
    prohibited_steps_moving_abduction: '0',
    orders_additional_details: orders_additional_details,
  } }

  let(:c100_application) {
    instance_double(C100Application, orders: orders)
  }

  let(:orders) { [] }
  let(:orders_additional_details) { nil }

  subject { described_class.new(arguments) }

  describe 'custom getters override' do
    let(:orders) { ['child_arrangements_home'] }

    it 'returns true if the order is in the list' do
      expect(subject.child_arrangements_home).to eq(true)
    end

    it 'returns false if the order is not in the list' do
      expect(subject.specific_issues_school).to eq(false)
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'for valid details' do
      it 'updates the record' do
        expect(c100_application).to receive(:update).with(
          orders: [:child_arrangements_home, :specific_issues_medical],
          orders_additional_details: nil,
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'for other issue details' do
        let(:orders_additional_details) { 'details' }

        it 'updates the record' do
          expect(c100_application).to receive(:update).with(
            orders: [:child_arrangements_home, :specific_issues_medical],
            orders_additional_details: 'details',
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
