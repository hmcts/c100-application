require 'spec_helper'

RSpec.describe Steps::Applicant::PersonalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    has_previous_name: has_previous_name,
    previous_name: previous_name,
    gender: gender,
    dob: dob,
    birthplace: birthplace,
  } }

  let(:c100_application) { instance_double(C100Application, applicants: applicants_collection) }
  let(:applicants_collection) { double('applicants_collection') }
  let(:applicant) { double('Applicant', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:has_previous_name) { 'no' }
  let(:previous_name) { nil }
  let(:gender) { 'male' }
  let(:dob) { Date.today }
  let(:birthplace) { 'London' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'has previous name' do
      it_behaves_like 'a previous name validation'
    end

    context 'gender' do
      it_behaves_like 'a gender validation'
    end

    context 'date of birth' do
      it_behaves_like 'a mandatory date of birth validation'
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          has_previous_name: GenericYesNo::NO,
          previous_name: '',
          gender: Gender::MALE,
          dob: Date.today,
          birthplace: 'London'
        }
      }

      context 'when record does not exist' do
        let(:record) { nil }

        it 'creates the record if it does not exist' do
          expect(applicants_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(applicant)

          expect(applicant).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:record) { applicant }

        it 'updates the record if it already exists' do
          expect(applicants_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(applicant)

          expect(applicant).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
