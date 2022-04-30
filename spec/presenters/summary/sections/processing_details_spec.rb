require 'spec_helper'

module Summary
  describe Sections::ProcessingDetails do
    let(:c100_application) {
      instance_double(C100Application, completed_at: completed_at, court: court)
    }

    subject { described_class.new(c100_application) }

    let(:completed_at) { Date.new(2020, 1, 31) }
    let(:county_location_code) { 123 }
    let(:court) { instance_double(Court, name: 'Foobar Court', county_location_code: county_location_code) }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:processing_details)
      end
    end

    describe '#answers' do
      let(:answers) { subject.answers }

      it 'has the correct rows' do
        expect(subject.answers.count).to eq(2)

        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].question).to eq(:court_name_and_code)
        expect(answers[0].value).to eq('123 - Foobar Court')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:completion_date)
        expect(answers[1].value).to eq('31/01/2020')
      end

      context 'for a court without code' do
        let(:county_location_code) { nil }

        it 'prints the name of the court, without the code' do
          expect(answers[0].value).to eq('Foobar Court')
        end
      end

      context 'for an application without completion date' do
        let(:completed_at) { nil }

        it 'does not print the date row, only the court row' do
          expect(subject.answers.count).to eq(1)
          expect(answers[0].question).to eq(:court_name_and_code)
        end
      end
    end
  end
end
