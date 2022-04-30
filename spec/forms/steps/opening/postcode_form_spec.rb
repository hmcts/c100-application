require 'spec_helper'

RSpec.describe Steps::Opening::PostcodeForm do
  let(:arguments) { {
    c100_application: c100_application,
    children_postcode: children_postcode
  } }

  let(:c100_application) { instance_double(C100Application) }
  let(:children_postcode) { 'E3 6AA' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      context 'when the attribute is not given' do
        it { should validate_presence_of(:children_postcode) }
      end

      context 'when the attribute is given' do
        context 'but not a valid full postcode' do
          let(:children_postcode) { 'SE1' }

          it 'is not valid' do
            expect(subject).to_not be_valid
          end

          it 'adds an error on the attribute' do
            subject.valid?
            expect(subject.errors[:children_postcode]).to_not be_empty
          end
        end

        context 'and is a valid postcode' do
          context 'without a space, upper case' do
            let(:children_postcode) { 'SW1H9AJ' }

            it 'is valid' do
              expect(subject).to be_valid
            end
          end

          context 'without a space, mixed case' do
            let(:children_postcode) { 'SW1h9aj' }

            it 'is valid' do
              expect(subject).to be_valid
            end
          end

          context 'with a space, upper case' do
            let(:children_postcode) { 'SW1H 9AJ' }

            it 'is valid' do
              expect(subject).to be_valid
            end
          end

          context 'with a space, mixed case' do
            let(:children_postcode) { 'SW1h 9aj' }

            it 'is valid' do
              expect(subject).to be_valid
            end
          end
        end
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          children_postcode: children_postcode,
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
