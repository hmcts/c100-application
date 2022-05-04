require 'spec_helper'

RSpec.describe Steps::AttendingCourt::LanguageForm do
  let(:arguments) { {
    c100_application: c100_application,
    language_options: language_options,
    language_interpreter_details: language_interpreter_details,
    sign_language_interpreter_details: sign_language_interpreter_details,
    welsh_language_details: welsh_language_details,
  } }

  let(:language_options) { ['language_interpreter'] }
  let(:language_interpreter_details) { 'details' }
  let(:sign_language_interpreter_details) { 'details' }
  let(:welsh_language_details) { 'details' }

  let(:c100_application) { instance_double(C100Application, court_arrangement: court_arrangement) }
  let(:court_arrangement) { CourtArrangement.new }

  subject { described_class.new(arguments) }

  describe 'custom query getter override' do
    it 'returns true if the attribute is in the list' do
      expect(subject.language_interpreter?).to eq(true)
    end

    it 'returns false if the attribute is not in the list' do
      expect(subject.sign_language_interpreter?).to eq(false)
    end

    it 'returns false if the attribute is not in the list' do
      expect(subject.welsh_language?).to eq(false)
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      context 'when `language_interpreter` is checked' do
        let(:language_options) { ['language_interpreter'] }
        it { should validate_presence_of(:language_interpreter_details) }
      end

      context 'when `language_interpreter` is not checked' do
        let(:language_options) { [] }
        it { should_not validate_presence_of(:language_interpreter_details) }
      end

      context 'when `sign_language_interpreter` is checked' do
        let(:language_options) { ['sign_language_interpreter'] }
        it { should validate_presence_of(:sign_language_interpreter_details) }
      end

      context 'when `sign_language_interpreter` is not checked' do
        let(:language_options) { [] }
        it { should_not validate_presence_of(:sign_language_interpreter_details) }
      end

      context 'when `welsh_language` is checked' do
        let(:language_options) { ['welsh_language'] }
        it { should validate_presence_of(:welsh_language_details) }
      end

      context 'when `welsh_language` is not checked' do
        let(:language_options) { [] }
        it { should_not validate_presence_of(:welsh_language_details) }
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(court_arrangement).to receive(:update).with(
          language_options: ['language_interpreter'],
          language_interpreter_details: 'details',
          sign_language_interpreter_details: nil,
          welsh_language_details: nil,
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'filters out invalid options (tampering)' do
        let(:language_options) { ['foobar'] }

        it 'saves the record' do
          expect(court_arrangement).to receive(:update).with(
            language_options: [],
            language_interpreter_details: nil,
            sign_language_interpreter_details: nil,
            welsh_language_details: nil,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end

    context 'ensure leftovers are deleted when deselecting a checkbox' do
      let(:language_interpreter_details) { nil }
      let(:sign_language_interpreter_details) { nil }
      let(:welsh_language_details) { nil }

      context '`language_interpreter` is not checked and `language_interpreter_details` is filled' do
        let(:language_options) { ['sign_language_interpreter'] }
        let(:language_interpreter_details) { 'language_interpreter_details' }
        let(:sign_language_interpreter_details) { 'sign_language_interpreter_details' }

        it 'saves the record' do
          expect(court_arrangement).to receive(:update).with(
            language_options: ['sign_language_interpreter'],
            language_interpreter_details: nil,
            sign_language_interpreter_details: 'sign_language_interpreter_details',
            welsh_language_details: nil,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context '`sign_language_interpreter` is not checked and `sign_language_interpreter_details` is filled' do
        let(:language_options) { ['welsh_language'] }
        let(:sign_language_interpreter_details) { 'sign_language_interpreter_details' }
        let(:welsh_language_details) { 'welsh_language_details' }

        it 'saves the record' do
          expect(court_arrangement).to receive(:update).with(
            language_options: ['welsh_language'],
            language_interpreter_details: nil,
            sign_language_interpreter_details: nil,
            welsh_language_details: 'welsh_language_details',
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context '`welsh_language` is not checked and `welsh_language_details` is filled' do
        let(:language_options) { ['language_interpreter'] }
        let(:welsh_language_details) { 'welsh_language_details' }
        let(:language_interpreter_details) { 'language_interpreter_details' }

        it 'saves the record' do
          expect(court_arrangement).to receive(:update).with(
            language_options: ['language_interpreter'],
            language_interpreter_details: 'language_interpreter_details',
            sign_language_interpreter_details: nil,
            welsh_language_details: nil,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
