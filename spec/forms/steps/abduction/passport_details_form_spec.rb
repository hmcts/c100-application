require 'spec_helper'

RSpec.describe Steps::Abduction::PassportDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    children_multiple_passports: 'no',
    passport_possession: passport_possession,
    passport_possession_other_details: passport_possession_other_details
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:passport_possession) { ['mother'] }
  let(:passport_possession_other_details) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:children_multiple_passports, :inclusion) }

      context 'when passport possession `other` is checked' do
        let(:passport_possession) { ['other'] }
        it { should validate_presence_of(:passport_possession_other_details) }
      end

      context 'when passport possession `other` is not checked' do
        it { should_not validate_presence_of(:passport_possession_other_details) }
      end
    end

    context 'when passport possession `other` is true and `passport_possession_other_details` is filled' do
      let(:passport_possession) { %w(mother other) }
      let(:passport_possession_other_details) { 'blah blah' }

      it_behaves_like 'a has-one-association form',
                      association_name: :abduction_detail,
                      expected_attributes: {
                        children_multiple_passports: GenericYesNo::NO,
                        passport_possession: %w(mother other),
                        passport_possession_other_details: 'blah blah'
                      }
    end

    context 'filters out invalid options (tampering)' do
      let(:passport_possession) { %w(father foobar) }

      it_behaves_like 'a has-one-association form',
                      association_name: :abduction_detail,
                      expected_attributes: {
                        children_multiple_passports: GenericYesNo::NO,
                        passport_possession: ['father'],
                        passport_possession_other_details: nil
                      }
    end

    # Mutant killer
    context 'when passport possession `other` is false and `passport_possession_other_details` is filled' do
      let(:passport_possession_other_details) { 'blah blah' }

      it_behaves_like 'a has-one-association form',
                      association_name: :abduction_detail,
                      expected_attributes: {
                        children_multiple_passports: GenericYesNo::NO,
                        passport_possession: ['mother'],
                        passport_possession_other_details: nil
                      }
    end
  end
end
