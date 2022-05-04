require 'spec_helper'

RSpec.describe Steps::MiamExemptions::AdrForm do
  let(:arguments) { {
    c100_application: c100_application,
    adr: ['previous_attendance'],
  } }

  let(:c100_application) { instance_double(C100Application, miam_exemption: miam_exemption_record) }
  let(:miam_exemption_record) { MiamExemption.new(adr: ['previous_attendance']) }

  subject { described_class.new(arguments) }

  describe 'custom getter override' do
    it 'returns all the exemptions in all attributes' do
      expect(subject.exemptions_collection).to eq(['previous_attendance'])
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when no checkboxes are selected' do
      let(:arguments) { {
        c100_application: c100_application,
      } }

      it 'does not save the record' do
        expect(miam_exemption_record).not_to receive(:update)
        expect(subject.save).to be(false)
      end

      it 'has a validation error' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:adr, :blank)).to eq(true)
      end
    end

    context 'when invalid checkbox values are submitted' do
      context 'in `adr` attribute' do
        let(:arguments) { {
          c100_application: c100_application,
          adr: ['foobar'],
        } }

        it 'does not save the record' do
          expect(miam_exemption_record).not_to receive(:update)
          expect(subject.save).to be(false)
        end

        it 'has a validation error' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(:adr, :blank)).to eq(true)
        end
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(miam_exemption_record).to receive(:update).with(
          adr: %w(previous_attendance),
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
