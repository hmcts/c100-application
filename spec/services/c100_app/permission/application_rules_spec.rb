require 'rails_helper'

RSpec.describe C100App::Permission::ApplicationRules do
  subject { described_class.new(c100_application) }

  let(:c100_application) { C100Application.new(consent_order: consent_order) }
  let(:relationship) { Relationship.new }

  let(:consent_order) { 'no' }
  let(:children_scope) { double('children_scope') }
  let(:children_with_sgo) { false }

  before do
    allow(c100_application).to receive(:children).and_return(children_scope)
    allow(children_scope).to receive(:with_special_guardianship_order?).and_return(children_with_sgo)
  end

  describe 'ALL_ORDERS' do
    let(:config) { described_class::ALL_ORDERS }

    context 'questions' do
      it { expect(config[:questions]).to match_array(%i[parental_responsibility living_order amendment time_order]) }
    end

    context 'allowed_orders' do
      it { expect(config[:allowed_orders]).to match_array(PetitionOrder.values) }
    end
  end

  describe 'CAO_ORDERS' do
    let(:config) { described_class::CAO_ORDERS }

    context 'questions' do
      it { expect(config[:questions]).to match_array(%i[living_arrangement consent family local_authority]) }
    end

    context 'allowed_orders' do
      it { expect(config[:allowed_orders]).to match_array([PetitionOrder::CHILD_ARRANGEMENTS_HOME, PetitionOrder::CHILD_ARRANGEMENTS_TIME]) }
    end
  end

  describe 'CAO_HOME_ORDERS' do
    let(:config) { described_class::CAO_HOME_ORDERS }

    context 'questions' do
      it { expect(config[:questions]).to match_array(%i[relative]) }
    end

    context 'allowed_orders' do
      it { expect(config[:allowed_orders]).to match_array([PetitionOrder::CHILD_ARRANGEMENTS_HOME]) }
    end
  end

  describe '#reset_permission_details!' do
    it 'updates with `nil` values the attributes' do
      expect(
        c100_application
      ).to receive(:update).with(
        permission_sought: nil,
        permission_details: nil,
      )

      subject.reset_permission_details!
    end
  end

  describe '#permission_needed?' do
    context 'when application is a consent order' do
      let(:consent_order) { 'yes' }

      it 'returns false' do
        expect(subject.permission_needed?).to eq(false)
      end

      it 'does not check any other rules' do
        expect(subject).not_to receive(:children_with_sgo?)
        expect(subject).not_to receive(:relationships_require_permission?)

        subject.permission_needed?
      end
    end

    context 'when at least one child has a special guardianship order in force' do
      let(:children_with_sgo) { true }

      it 'returns true' do
        expect(subject.permission_needed?).to eq(true)
      end
    end

    context 'rules based on relationships and orders' do
      let(:relationships_scope) { double('relationships_scope', with_permission_data: relationships) }
      let(:relationships) { [relationship] }

      let(:child) { instance_double(Child, child_order: child_order) }
      let(:child_order) { instance_double(ChildOrder, orders: orders) }
      let(:orders) { ['foobar'] }

      before do
        allow(c100_application).to receive(:relationships).and_return(relationships_scope)
        allow(relationship).to receive(:minor).and_return(child)
      end

      context 'when no relationships were found' do
        let(:relationships) { [] }

        it 'returns false' do
          expect(subject.permission_needed?).to eq(false)
        end
      end

      context 'can apply for any order' do
        let(:relationship) {
          Relationship.new(
            living_order: 'yes',
          )
        }

        it 'returns false' do
          expect(subject.permission_needed?).to eq(false)
        end
      end

      context 'can apply for any CAO orders' do
        let(:relationship) {
          Relationship.new(
            family: 'yes',
          )
        }

        context 'orders meet the rules' do
          let(:orders) { %w(child_arrangements_home child_arrangements_time) }

          it 'returns false' do
            expect(subject.permission_needed?).to eq(false)
          end
        end

        context 'orders does not meet the rules' do
          let(:orders) { %w(prohibited_steps_holiday child_arrangements_time) }

          it 'returns true' do
            expect(subject.permission_needed?).to eq(true)
          end
        end
      end

      context 'can only apply for CAO home order' do
        let(:relationship) {
          Relationship.new(
            relative: 'yes',
          )
        }

        context 'orders meet the rules' do
          let(:orders) { %w(child_arrangements_home) }

          it 'returns false' do
            expect(subject.permission_needed?).to eq(false)
          end
        end

        context 'orders does not meet the rules' do
          let(:orders) { %w(child_arrangements_home child_arrangements_time) }

          it 'returns true' do
            expect(subject.permission_needed?).to eq(true)
          end
        end
      end

      context 'permission required for all orders' do
        let(:relationship) {
          Relationship.new(
            relative: 'no',
          )
        }

        let(:orders) { %w(child_arrangements_home) }

        it 'returns true' do
          expect(subject.permission_needed?).to eq(true)
        end
      end

      # mutant kills
      context 'when there are more than 1 relationships' do
        let(:relationships) { [relationship1, relationship2] }
        let(:orders) { ['child_arrangements_home'] }

        before do
          allow(relationship1).to receive(:minor).and_return(child)
          allow(relationship2).to receive(:minor).and_return(child)
        end

        context 'and the first relationship requires permission' do
          let(:relationship1) { Relationship.new(relative: 'no') }
          let(:relationship2) { Relationship.new(family: 'yes') }

          it 'returns true' do
            expect(subject.permission_needed?).to eq(true)
          end

          it 'breaks the loop as soon as we know there is no need to keep going' do
            expect(subject).not_to receive(:can_apply_for?).with(
              anything, relationship: relationship2, child_orders: anything
            )

            subject.permission_needed?
          end
        end

        context 'and the first relationship does not require permission but the second does' do
          let(:relationship1) { Relationship.new(family: 'yes') }
          let(:relationship2) { Relationship.new(relative: 'no') }

          it 'returns true' do
            expect(subject.permission_needed?).to eq(true)
          end
        end
      end
    end
  end
end
