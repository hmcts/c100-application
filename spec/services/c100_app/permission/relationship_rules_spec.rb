require 'rails_helper'

RSpec.describe C100App::Permission::RelationshipRules do
  subject { described_class.new(relationship) }

  let(:relationship) {
    instance_double(
      Relationship,
      c100_application: c100_application,
      minor: child,
      relation: relation
    )
  }

  let(:c100_application) { C100Application.new(consent_order: consent_order) }
  let(:child) { instance_double(Child, special_guardianship_order: sgo_order) }

  let(:sgo_order) { nil }
  let(:relation)  { 'father' }
  let(:consent_order) { 'no' }

  describe '#permission_undecided?' do
    context 'when application is a consent order' do
      let(:consent_order) { 'yes' }

      it 'returns false' do
        expect(subject.permission_undecided?).to eq(false)
      end

      it 'does not check any other rules' do
        expect(subject).not_to receive(:other_relationship?)

        subject.permission_undecided?
      end
    end

    context 'when relationship is with other child (`OtherChild`)' do
      let(:child) { OtherChild.new }

      it 'returns false' do
        expect(subject.permission_undecided?).to eq(false)
      end

      it 'does not check any other rules' do
        expect(subject).not_to receive(:other_relationship?)

        subject.permission_undecided?
      end
    end

    context 'when `special_guardianship_order` is `nil`' do
      it 'returns false' do
        expect(subject.permission_undecided?).to eq(false)
      end

      it 'keeps running any other rules' do
        expect(subject).to receive(:other_relationship?)

        subject.permission_undecided?
      end
    end

    context 'when `special_guardianship_order` is `yes`' do
      let(:sgo_order) { 'yes' }

      it 'returns false' do
        expect(subject.permission_undecided?).to eq(false)
      end

      it 'does not check any other rules' do
        expect(subject).not_to receive(:other_relationship?)

        subject.permission_undecided?
      end
    end

    context 'when `special_guardianship_order` is `no`' do
      let(:sgo_order) { 'no' }

      context 'when the relation is not `other`' do
        it 'returns false' do
          expect(subject.permission_undecided?).to eq(false)
        end
      end

      context 'when the relation is `other`' do
        let(:relation) { 'other' }

        it 'returns true' do
          expect(subject.permission_undecided?).to eq(true)
        end
      end
    end
  end
end
