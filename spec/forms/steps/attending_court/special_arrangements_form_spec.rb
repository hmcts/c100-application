require 'spec_helper'

RSpec.describe Steps::AttendingCourt::SpecialArrangementsForm do
  let(:arguments) { {
    c100_application: c100_application,
    special_arrangements: special_arrangements,
    special_arrangements_details: 'details',
  } }

  let(:special_arrangements) { ['video_link'] }

  let(:c100_application) { instance_double(C100Application, court_arrangement: court_arrangement) }
  let(:court_arrangement) { CourtArrangement.new }

  subject { described_class.new(arguments) }

  describe 'custom query getter override' do
    it 'returns true if the attribute is in the list' do
      expect(subject.video_link?).to eq(true)
    end

    it 'returns false if the attribute is not in the list' do
      expect(subject.separate_entrance_exit?).to eq(false)
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(court_arrangement).to receive(:update).with(
          special_arrangements: ['video_link'],
          special_arrangements_details: 'details'
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'filters out invalid options (tampering)' do
        let(:special_arrangements) { ['foobar'] }

        it 'saves the record' do
          expect(court_arrangement).to receive(:update).with(
            special_arrangements: [],
            special_arrangements_details: 'details'
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
