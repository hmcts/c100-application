require 'spec_helper'

RSpec.describe Steps::Children::PersonalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    gender: gender,
    dob: dob,
    dob_unknown: dob_unknown,
    dob_estimate: dob_estimate
  } }

  let(:c100_application) { instance_double(C100Application, children: children_collection) }
  let(:children_collection) { double('children_collection') }
  let(:child) { double('Child', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:gender) { 'male' }
  let(:dob) { Date.today }
  let(:dob_unknown) { false }
  let(:dob_estimate) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'gender' do
      it_behaves_like 'a gender validation'
    end

    context 'date of birth' do
      it_behaves_like 'a date of birth validation with unknown checkbox'
    end

    context 'for valid details' do
      let(:dob_unknown) { false }
      let(:dob_estimate) { nil }
      let(:dob) { Date.today }
      let(:expected_attributes) {
        {
          gender: Gender::MALE,
          dob: dob,
          dob_unknown: dob_unknown,
          dob_estimate: dob_estimate
        }
      }

      context 'when record does not exist' do
        let(:record) { nil }

        it 'creates the record if it does not exist' do
          expect(children_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(child)

          expect(child).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'cannot have both dob and dob_unknown' do
        let(:dob_unknown) { true }
        it 'is not valid' do
          expect(subject.valid?).to be(false)
        end
      end

      context 'cannot have both dob and dob_estimate' do
        let(:dob_estimate) { Date.today }
        it 'is not valid' do
          expect(subject.valid?).to be(false)
        end
      end

      context 'when record already exists' do
        let(:record) { child }

        it 'updates the record if it already exists' do
          expect(children_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(child)

          expect(child).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
