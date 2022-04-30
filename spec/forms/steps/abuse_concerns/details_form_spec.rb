require 'spec_helper'

RSpec.describe Steps::AbuseConcerns::DetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    subject: abuse_subject,
    kind: abuse_kind,
    behaviour_description: behaviour_description,
    behaviour_start: behaviour_start,
    behaviour_ongoing: behaviour_ongoing,
    behaviour_stop: behaviour_stop,
    asked_for_help: asked_for_help,
    help_party: help_party,
    help_provided: help_provided,
    help_description: help_description
  } }

  let(:c100_application) { instance_double(C100Application, abuse_concerns: concerns_collection) }
  let(:concerns_collection) { double('concerns_collection') }
  let(:abuse_concern) { double('abuse_concern') }

  let(:abuse_subject) {'applicant'}
  let(:abuse_kind) {'emotional'}
  let(:behaviour_description) { 'a description' }
  let(:behaviour_start) { '1 year ago' }
  let(:behaviour_ongoing) { GenericYesNo::NO }
  let(:behaviour_stop) { 'last monday' }
  let(:asked_for_help) { GenericYesNo::YES }
  let(:help_party) { 'doctor' }
  let(:help_provided) { GenericYesNo::YES }
  let(:help_description) { 'description' }

  subject { described_class.new(arguments) }

  describe '.i18n_key' do
    context 'for an applicant subject' do
      let(:abuse_subject) { 'applicant' }
      it { expect(subject.i18n_key).to eq('applicant.emotional') }
    end

    context 'for a children subject' do
      let(:abuse_subject) { 'children' }
      it { expect(subject.i18n_key).to eq('children.emotional') }
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
      before do
        allow(concerns_collection).to receive(:find_or_initialize_by).with(
          subject: AbuseSubject::APPLICANT,
          kind: AbuseType::EMOTIONAL
        ).and_return(abuse_concern)
      end

      it 'creates the record if it does not exist' do
        expect(abuse_concern).to receive(:update).with(
          behaviour_description: 'a description',
          behaviour_start: '1 year ago',
          behaviour_ongoing: GenericYesNo::NO,
          behaviour_stop: 'last monday',
          asked_for_help: GenericYesNo::YES,
          help_party: 'doctor',
          help_provided: GenericYesNo::YES,
          help_description: 'description'
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'when `asked_for_help` is no' do
        let(:asked_for_help) { 'no' }
        let(:help_party) { nil }
        let(:help_provided) { nil }
        let(:help_description) { nil}

        # mutant killer, really
        it 'has the right attributes' do
          expect(abuse_concern).to receive(:update).with(
            hash_including(
              asked_for_help: GenericYesNo::NO,
              help_party: nil,
              help_provided: nil,
              help_description: nil
            )
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end

    context 'for invalid details' do
      before do
        allow(concerns_collection).to receive(:find_or_initialize_by).with(
          subject: AbuseSubject::APPLICANT,
          kind: AbuseType::EMOTIONAL
        ).and_return(abuse_concern)
      end

      before(:each, saves: true) do
        expect(abuse_concern).to receive(:update).with(
          behaviour_description: behaviour_description,
          behaviour_start: behaviour_start,
          behaviour_ongoing: behaviour_ongoing,
          behaviour_stop: behaviour_stop,
          asked_for_help: asked_for_help,
          help_party: help_party,
          help_provided: help_provided,
          help_description: help_description
        ).and_return(true)
      end

      context 'requires behaviour_description' do
        let(:behaviour_description){ nil }
        it{ expect(subject.save).to be(false) }
      end
      context 'requires behaviour_start' do
        let(:behaviour_start){ nil }
        it{ expect(subject.save).to be(false) }
      end
      context 'requires behaviour_ongoing' do
        let(:behaviour_ongoing){ nil }
        it{ expect(subject.save).to be(false) }
      end
      context 'requires behaviour_stop if behaviour_ongoing is no' do
        let(:behaviour_ongoing){ GenericYesNo::NO }
        let(:behaviour_stop){ nil }
        it{ expect(subject.save).to be(false) }
      end
      context 'does not require behaviour_stop if behaviour_ongoing is yes',
              saves: true do
        let(:behaviour_ongoing){ GenericYesNo::YES }
        let(:behaviour_stop){ nil }
        it{ expect(subject.save).to be(true) }
      end
      context 'requires asked_for_help' do
        let(:asked_for_help){ nil }
        it{ expect(subject.save).to be(false) }
      end
      context 'requires help_party if asked_for_help is yes' do
        let(:asked_for_help){ GenericYesNo::YES }
        let(:help_party){ nil }
        it{ expect(subject.save).to be(false) }
      end
      context 'does not require help_party if asked_for_help is no', saves: true do
        let(:asked_for_help){ GenericYesNo::NO }
        let(:help_party){ nil }
        it{ expect(subject.save).to be(true) }
      end
      context 'requires help_provided if asked_for_help is yes' do
        let(:asked_for_help){ GenericYesNo::YES }
        let(:help_provided){ nil }
        it{ expect(subject.save).to be(false) }
      end
      context 'does not require help_provided if asked_for_help is no', saves: true do
        let(:asked_for_help){ GenericYesNo::NO }
        let(:help_provided){ nil }
        it{ expect(subject.save).to be(true) }
      end
      context 'requires help_description if asked_for_help'+
         ' is yes and help_provided yes' do
        let(:asked_for_help){ GenericYesNo::YES }
        let(:help_provided){ GenericYesNo::YES }
        let(:help_description){ nil }
        it{ expect(subject.save).to be(false) }
      end
      context 'does not require help_description if asked_for_help is no',
              saves: true do
        let(:asked_for_help){ GenericYesNo::NO }
        let(:help_provided){ GenericYesNo::NO }
        let(:help_description){ nil }
        it{ expect(subject.save).to be(true) }
      end
      context 'does not require help_description if asked_for_help is yes'+
         ' and help_provided no', saves: true do
        let(:asked_for_help){ GenericYesNo::YES }
        let(:help_provided){ GenericYesNo::NO }
        let(:help_description){ nil }
        it{ expect(subject.save).to be(true) }
      end
    end
  end
end
