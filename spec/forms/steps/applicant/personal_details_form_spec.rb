require 'spec_helper'

RSpec.describe Steps::Applicant::PersonalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    personal_details: personal_details
  } }
  let(:c100_application) { instance_double(C100Application, personal_details: nil) }
  let(:personal_details) { nil }

  subject { described_class.new(arguments) }

  pending 'Write specs for PersonalDetailsForm!'

  # TODO: The below can be uncommented and serves as a starting point for
  #   forms operating on a single value object.

  # describe '.choices' do
  #   it 'returns the relevant choices' do
  #     expect(described_class.choices).to eq(%w(
  #       one_choice
  #       another_choice
  #     ))
  #   end
  # end

  # describe '#save' do
  #   it_behaves_like 'a value object form', attribute_name: personal_details, example_value: 'INSERT VALID VALUE HERE'

  #   context 'when personal_details is valid' do
  #     let(:personal_details) { 'INSERT VALID VALUE HERE' }

  #     it 'saves the record' do
  #       expect(c100_application).to receive(:update).with(
  #         # TODO: What's in the update?
  #       ).and_return(true)
  #       expect(subject.save).to be(true)
  #     end
  #   end

  #   context 'when personal_details is already the same on the model' do
  #     let(:c100_application) {
  #       instance_double(
  #         C100Application,
  #         personal_details: 'INSERT EXISTING VALUE HERE'
  #       )
  #     }
  #     let(:personal_details) { 'CHANGEME' }

  #     it 'does not save the record but returns true' do
  #       expect(c100_application).to_not receive(:update)
  #       expect(subject.save).to be(true)
  #     end

  #     # This is a mutant killer. Uncomment and change method names if needed.
  #     it 'checks if the form should be saved or bypass the save' do
  #       expect(subject).to receive(:changed?).and_call_original
  #       expect(subject).to receive(:help_paying_value).and_call_original
  #       subject.save
  #     end
  #   end
  # end
end
