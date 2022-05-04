require 'spec_helper'

RSpec.describe Steps::Opening::ResearchConsentForm do
  let(:arguments) { {
    c100_application: c100_application,
    research_consent: research_consent,
    research_consent_email: research_consent_email,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:research_consent) { 'no' }
  let(:research_consent_email) { nil }

  subject { described_class.new(arguments) }

  context 'when no c100_application is associated with the form' do
    let(:c100_application) { nil }

    it 'raises an error' do
      expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
    end
  end

  context 'validations' do
    it { should validate_presence_of(:research_consent, :inclusion) }

    context 'research_consent_email attribute' do
      let(:research_consent) { 'no' }

      context 'when consent is `no`' do
        it { should_not validate_presence_of(:research_consent_email) }
      end

      context 'when consent is `yes`' do
        let(:research_consent) { 'yes' }

        it { should validate_presence_of(:research_consent_email) }

        context 'email is invalid' do
          let(:research_consent_email) { 'xxx' }

          it {
            expect(subject).not_to be_valid
            expect(subject.errors.added?(:research_consent_email, :invalid)).to eq(true)
          }
        end

        context 'email domain contains a typo' do
          let(:research_consent_email) { 'test@gamil.com' }

          it {
            expect(subject).not_to be_valid
            expect(subject.errors.added?(:research_consent_email, :typo)).to eq(true)
          }
        end
      end
    end
  end

  describe '#save' do
    context 'when form is valid' do
      context 'when `research_consent` is `yes`' do
        let(:research_consent) { 'yes' }
        let(:research_consent_email) { 'test@example.com' }

        it 'saves the record' do
          expect(c100_application).to receive(:update).with(
            research_consent: GenericYesNo::YES,
            research_consent_email: research_consent_email,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when `research_consent` is `no`' do
        let(:research_consent) { 'no' }

        it 'saves the record' do
          expect(c100_application).to receive(:update).with(
            research_consent: GenericYesNo::NO,
            research_consent_email: nil,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
