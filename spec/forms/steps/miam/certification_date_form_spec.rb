require 'spec_helper'

RSpec.describe Steps::Miam::CertificationDateForm do
  let(:arguments) { {
    c100_application: c100_application,
    miam_certification_date: miam_certification_date
  } }
  let(:c100_application) { instance_double(C100Application) }
  let(:miam_certification_date) { 3.months.ago.to_date }

  subject { described_class.new(arguments) }

  describe '#save' do
    it { should validate_presence_of(:miam_certification_date) }

    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'certification date validation' do
      context 'when date is not given' do
        let(:miam_certification_date) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(:miam_certification_date, :blank)).to eq(true)
        end
      end

      context 'when date is invalid' do
        let(:miam_certification_date) { Date.new(18, 10, 31) } # 2-digits year (18)

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(:miam_certification_date, :invalid)).to eq(true)
        end
      end

      context 'when date is in the future' do
        let(:miam_certification_date) { Date.tomorrow }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(:miam_certification_date, :future)).to eq(true)
        end
      end

      context 'casting the date from multi parameters' do
        context 'when date is valid' do
          let(:miam_certification_date) { [nil, 2008, 11, 22] }
          it { expect(subject).to be_valid }
        end

        context 'when date is not valid' do
          let(:miam_certification_date) { [nil, 18, 11, 22] } # 2-digits year (18)
          it { expect(subject).not_to be_valid }
        end

        context 'when a part is missing (nil or zero)' do
          let(:miam_certification_date) { [nil, 2008, 0, 22] }
          it { expect(subject).not_to be_valid }
        end
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          miam_certification_date: 3.months.ago.to_date
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
