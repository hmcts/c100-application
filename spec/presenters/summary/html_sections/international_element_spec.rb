require 'spec_helper'

module Summary
  describe HtmlSections::InternationalElement do
    let(:c100_application) {
      instance_double(C100Application,
        international_resident: 'yes',
        international_resident_details: 'international resident details',
        international_jurisdiction: 'yes',
        international_jurisdiction_details: 'international jurisdiction details',
        international_request: 'yes',
        international_request_details: 'international request details',
      )
    }
    let(:answers) { subject.answers }
    subject { described_class.new(c100_application) }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:international_element)
      end
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(3)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(AnswersGroup)
        expect(answers[0].name).to eq(:international_resident)
        expect(answers[0].change_path).to eq('/steps/international/resident')

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:international_jurisdiction)
        expect(answers[1].change_path).to eq('/steps/international/jurisdiction')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:international_request)
        expect(answers[2].change_path).to eq('/steps/international/request')
      end
    end

    describe 'the international_resident group' do
      let(:group){ answers[0] }

      it 'has the right questions in the right order' do
        expect(group.answers[0]).to be_an_instance_of(Answer)
        expect(group.answers[0].question).to eq(:international_resident)
        expect(group.answers[0].value).to eq('yes')

        expect(group.answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(group.answers[1].question).to eq(:international_resident_details)
        expect(group.answers[1].value).to eq('international resident details')
      end
    end

    describe 'the international_jurisdiction group' do
      let(:group){ answers[1] }

      it 'has the right questions in the right order' do
        expect(group.answers[0]).to be_an_instance_of(Answer)
        expect(group.answers[0].question).to eq(:international_jurisdiction)
        expect(group.answers[0].value).to eq('yes')

        expect(group.answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(group.answers[1].question).to eq(:international_jurisdiction_details)
        expect(group.answers[1].value).to eq('international jurisdiction details')
      end
    end

    describe 'the international_request group' do
      let(:group){ answers[2] }

      it 'has the right questions in the right order' do
        expect(group.answers[0]).to be_an_instance_of(Answer)
        expect(group.answers[0].question).to eq(:international_request)
        expect(group.answers[0].value).to eq('yes')

        expect(group.answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(group.answers[1].question).to eq(:international_request_details)
        expect(group.answers[1].value).to eq('international request details')
      end
    end

  end
end
