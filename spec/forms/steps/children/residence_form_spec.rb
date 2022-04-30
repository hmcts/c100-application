require 'spec_helper'

RSpec.describe Steps::Children::ResidenceForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    person_ids: person_ids,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:record) { double('Residence') }
  let(:person_ids) {%w(123 456)}

  subject { described_class.new(arguments) }

  describe '#people' do
    it 'returns a flattened collection of all the people children can live with' do
      expect(c100_application).to receive(:applicants).and_return(['a'])
      expect(c100_application).to receive(:respondents).and_return(['b', 'c'])
      expect(c100_application).to receive(:other_parties).and_return(['d'])

      expect(subject.people).to eq(%w(a b c d))
    end
  end

  describe 'validations' do
    before do
      allow(subject).to receive(:people).and_return([double(id: '12345')])
    end

    context 'when a valid checkbox is selected' do
      let(:person_ids) { '12345' }

      it 'has no validation error' do
        expect(subject).to be_valid
      end
    end

    context 'when no checkboxes are selected' do
      let(:person_ids) { nil }

      it 'has a validation error' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:person_ids, :blank)).to eq(true)
      end
    end

    context 'when invalid checkbox values are submitted' do
      let(:person_ids) { ['foobar'] }

      it 'has a validation error' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:person_ids, :blank)).to eq(true)
      end
    end
  end

  describe '#save' do
    before do
      allow(subject).to receive(:people).and_return(
        [
          double(id: '123'),
          double(id: '456'),
        ]
      )
    end

    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'for valid details' do
      it 'updates the record' do
        expect(record).to receive(:update).with(
          person_ids: person_ids,
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
