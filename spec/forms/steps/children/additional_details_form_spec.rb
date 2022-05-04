require 'spec_helper'

RSpec.describe Steps::Children::AdditionalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    children_known_to_authorities: children_known_to_authorities,
    children_known_to_authorities_details: children_known_to_authorities_details,
    children_protection_plan: children_protection_plan
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:children_known_to_authorities) { 'unknown' }
  let(:children_known_to_authorities_details) { nil }
  let(:children_protection_plan) { 'yes' }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :children_protection_plan, example_value: 'yes'

    context 'validations on field presence' do
      it {should validate_presence_of(:children_known_to_authorities, :inclusion)}
      it {should validate_presence_of(:children_protection_plan, :inclusion)}
    end

    context 'validation for `children_known_to_authorities` option' do
      context 'when answer is `yes`' do
        let(:children_known_to_authorities) {'yes'}
        it {should validate_presence_of(:children_known_to_authorities_details)}
      end

      context 'when answer is `no`' do
        let(:children_known_to_authorities) {'no'}
        it {should_not validate_presence_of(:children_known_to_authorities_details)}
      end
    end

    context 'when form object is valid' do
      context 'when `children_known_to_authorities` is YES' do
        let(:children_known_to_authorities) { 'yes' }
        let(:children_known_to_authorities_details) { 'details' }

        it 'saves the record, with the details' do
          expect(c100_application).to receive(:update).with(
            {
              children_known_to_authorities: GenericYesNoUnknown::YES,
              children_known_to_authorities_details: 'details',
              children_protection_plan: GenericYesNoUnknown::YES,
            }
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when `children_known_to_authorities` is NO' do
        let(:children_known_to_authorities) { 'no' }
        let(:children_known_to_authorities_details) { 'details' }

        it 'saves the record, resetting the details' do
          expect(c100_application).to receive(:update).with(
            {
              children_known_to_authorities: GenericYesNoUnknown::NO,
              children_known_to_authorities_details: nil,
              children_protection_plan: GenericYesNoUnknown::YES,
            }
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
