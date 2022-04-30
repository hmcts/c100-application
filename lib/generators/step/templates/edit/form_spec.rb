require 'spec_helper'

RSpec.describe Steps::<%= task_name.camelize %>::<%= step_name.camelize %>Form do
  let(:arguments) { {
    c100_application: c100_application,
    <%= step_name.underscore %>: <%= step_name.underscore %>
  } }
  let(:c100_application) { instance_double(C100Application, <%= step_name.underscore %>: nil) }
  let(:<%= step_name.underscore %>) { nil }

  subject { described_class.new(arguments) }

  pending 'Write specs for <%= step_name.camelize %>Form!'

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
  #   it_behaves_like 'a value object form', attribute_name: :<%= step_name.underscore %>, example_value: 'INSERT VALID VALUE HERE'

  #   context 'when form is valid' do
  #     let(:<%= step_name.underscore %>) { 'INSERT VALID VALUE HERE' }

  #     it 'saves the record' do
  #       expect(c100_application).to receive(:update).with(
  #         # TODO: What's in the update?
  #       ).and_return(true)
  #       expect(subject.save).to be(true)
  #     end
  #   end

  #   context 'when attributes are the same on the model' do
  #     let(:c100_application) {
  #       instance_double(
  #         C100Application,
  #         <%= step_name.underscore %>: 'INSERT EXISTING VALUE HERE'
  #       )
  #     }
  #     let(:<%= step_name.underscore %>) { 'CHANGEME' }

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
