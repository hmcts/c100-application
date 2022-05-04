require 'spec_helper'

RSpec.describe Steps::Shared::UnderAgeForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    under_age: under_age,
  } }

  let(:c100_application) { instance_double(C100Application, applicants: applicants_collection) }
  let(:applicants_collection) { double('applicants_collection') }
  let(:applicant) { double('Applicant', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:under_age) { true }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      it { should validate_presence_of(:under_age) }
    end

    context 'when a record exists' do
      let(:record) { applicant }

      it 'saves the record' do
        expect(applicants_collection).to receive(:find_or_initialize_by).with(
          id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6',
        ).and_return(applicant)

        expect(applicant).to receive(:update).with(
          under_age: under_age,
        ).and_return(true)

        expect(subject.save).to be true
      end
    end

    context 'when a record does not exist' do
      it 'creates a new applicant record' do
        expect(applicants_collection).to receive(:find_or_initialize_by).with(
          id: nil
        ).and_return(applicant)

        expect(applicant).to receive(:update).with(
          under_age: under_age
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
