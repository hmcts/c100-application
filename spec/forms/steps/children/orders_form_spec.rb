require 'spec_helper'

RSpec.describe Steps::Children::OrdersForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: child,
    orders: orders,
  } }

  let(:c100_application) { instance_double(C100Application) }
  let(:child) { instance_double(Child, child_order: child_order) }
  let(:child_order) { nil }

  let(:orders) { %w(child_arrangements_home specific_issues_medical) }

  subject { described_class.new(arguments) }

  describe 'validations' do
    let(:child_order) { double('child_order', orders: []) }

    context 'when no checkboxes are selected' do
      let(:orders) { nil }

      it 'has a validation error' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:orders, :blank)).to eq(true)
      end
    end

    context 'when invalid checkbox values are submitted' do
      let(:orders) { ['foobar'] }

      it 'has a validation error' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:orders, :blank)).to eq(true)
      end
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

      context 'when child_order does not exist' do
        let(:child_order) { nil }
        let(:new_child_order) { instance_double(ChildOrder, orders: []) }

        it 'creates the record if it does not exist' do
          expect(child).to receive(:build_child_order).and_return(new_child_order)

          expect(new_child_order).to receive(:update).with(
            orders: orders
          ).and_return(true)

          expect(child).to receive(:update).with(
            special_guardianship_order: nil
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:child_order) { instance_double(ChildOrder, orders: existing_orders) }

        context 'and there are changes in the orders' do
          let(:existing_orders) { ['prohibited_steps_holiday'] }

          it 'updates the record if it already exists' do
            expect(child).to receive(:child_order).and_return(child_order)

            expect(child_order).to receive(:update).with(
              orders: orders
            ).and_return(true)

            expect(child).to receive(:update).with(
              special_guardianship_order: nil
            ).and_return(true)

            expect(subject.save).to be(true)
          end
        end

        context 'and there are no changes in the orders' do
          let(:existing_orders) { orders }

          it 'does not save the record but returns true' do
            expect(child_order).not_to receive(:update)
            expect(child).not_to receive(:update)

            expect(subject.save).to be(true)
          end
        end
      end
    end
  end
end
