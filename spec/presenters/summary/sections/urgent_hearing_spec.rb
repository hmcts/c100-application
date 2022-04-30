require 'spec_helper'

module Summary
  describe Sections::UrgentHearing do
    let(:c100_application) {
      instance_double(
        C100Application,
        urgent_hearing: 'yes',
        urgent_hearing_details: 'details',
        urgent_hearing_when: 'when',
        urgent_hearing_short_notice: 'yes',
        urgent_hearing_short_notice_details: 'short notice details',
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:urgent_hearing) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(5)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:urgent_hearing)
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:urgent_hearing_details)
        expect(answers[1].value).to eq('details')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:urgent_hearing_when)
        expect(answers[2].value).to eq('when')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:urgent_hearing_short_notice)
        expect(answers[3].value).to eq('yes')

        expect(answers[4]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[4].question).to eq(:urgent_hearing_short_notice_details)
        expect(answers[4].value).to eq('short notice details')
      end
    end
  end
end
