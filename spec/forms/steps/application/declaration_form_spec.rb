require 'spec_helper'

RSpec.describe Steps::Application::DeclarationForm do
  let(:arguments) { {
    c100_application: c100_application,
    declaration_signee: declaration_signee,
    declaration_signee_capacity: declaration_signee_capacity,
    declaration_confirmation: declaration_confirmation,
  } }

  let(:c100_application) { instance_double(C100Application) }
  let(:declaration_signee) { 'Full Name' }
  let(:declaration_signee_capacity) { 'applicant' }
  let(:declaration_confirmation) { 'applicant' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      before do
        allow(c100_application).to receive(:valid?)
      end

      it { should validate_presence_of(:declaration_signee) }
      it { should validate_presence_of(:declaration_signee_capacity, :inclusion) }
      it { should validate_presence_of(:declaration_confirmation, :inclusion) }
    end

    context 'when application fulfilment is successful' do
      before do
        allow(c100_application).to receive(:valid?).with(:completion).and_return(true)
      end

      context 'and form is valid' do
        it 'saves the record' do
          expect(c100_application).to receive(:update).with(
            declaration_signee: 'Full Name',
            declaration_signee_capacity: 'applicant',
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'and form is not valid' do
        let(:declaration_signee_capacity) { nil }

        it 'returns false' do
          expect(c100_application).not_to receive(:update)
          expect(subject.save).to eq(false)
        end
      end
    end

    context 'when application fulfilment fails' do
      before do
        allow(c100_application).to receive(:valid?).with(:completion).and_return(false)
      end

      it 'has an error in the `c100_application` attribute' do
        subject.save
        expect(subject.errors.added?(:c100_application, :invalid)).to eq(true)
      end

      it 'returns false' do
        expect(c100_application).not_to receive(:update)
        expect(subject.save).to eq(false)
      end
    end
  end
end
