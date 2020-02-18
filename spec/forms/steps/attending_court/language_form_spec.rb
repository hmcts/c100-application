require 'spec_helper'

RSpec.describe Steps::AttendingCourt::LanguageForm do
  let(:arguments) { {
    c100_application: c100_application,
    language_interpreter: language_interpreter,
    sign_language_interpreter: sign_language_interpreter,
    language_interpreter_details: language_interpreter_details,
    sign_language_interpreter_details: sign_language_interpreter_details,
  } }

  let(:language_interpreter) { '1' }
  let(:language_interpreter_details) { 'details' }
  let(:sign_language_interpreter) { '0' }
  let(:sign_language_interpreter_details) { 'details' }

  let(:c100_application) { instance_double(C100Application, court_arrangement: court_arrangement) }
  let(:court_arrangement) { CourtArrangement.new(language_options: ['language_interpreter'], language_interpreter_details: 'details', sign_language_interpreter_details: '') }

  subject { described_class.new(arguments) }

  describe 'custom getters override' do
    it 'returns true if the attribute is in the list' do
      expect(subject.language_interpreter).to eq(true)
    end

    it 'returns false if the attribute is not in the list' do
      expect(subject.sign_language_interpreter).to eq(false)
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
        let(:language_interpreter) { true }
        it { should validate_presence_of(:language_interpreter_details) }
      end

      context 'when `language_interpreter` is not checked' do
        let(:language_interpreter) { false }
        it { should_not validate_presence_of(:language_interpreter_details) }
      end

      context 'when `sign_language_interpreter` is checked' do
        let(:sign_language_interpreter) { true }
        it { should validate_presence_of(:sign_language_interpreter_details) }
      end

      context 'when `sign_language_interpreter` is not checked' do
        let(:sign_language_interpreter) { false }
        it { should_not validate_presence_of(:sign_language_interpreter_details) }
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(court_arrangement).to receive(:update).with(
          language_options: [:language_interpreter],
          language_interpreter_details: 'details',
          sign_language_interpreter_details: nil,
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end

    context 'ensure leftovers are deleted when deselecting a checkbox' do
      context '`language_interpreter` is not checked and `language_interpreter_details` is filled' do
        let(:language_interpreter) { '0' }
        let(:sign_language_interpreter) { '1' }
        let(:language_interpreter_details) { 'language_interpreter_details' }
        let(:sign_language_interpreter_details) { 'sign_language_interpreter_details' }

        it 'saves the record' do
          expect(court_arrangement).to receive(:update).with(
            language_options: [:sign_language_interpreter],
            language_interpreter_details: nil,
            sign_language_interpreter_details: 'sign_language_interpreter_details',
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context '`sign_language_interpreter` is not checked and `sign_language_interpreter_details` is filled' do
        let(:language_interpreter) { '1' }
        let(:sign_language_interpreter) { '0' }
        let(:language_interpreter_details) { 'language_interpreter_details' }
        let(:sign_language_interpreter_details) { 'sign_language_interpreter_details' }

        it 'saves the record' do
          expect(court_arrangement).to receive(:update).with(
            language_options: [:language_interpreter],
            language_interpreter_details: 'language_interpreter_details',
            sign_language_interpreter_details: nil,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end