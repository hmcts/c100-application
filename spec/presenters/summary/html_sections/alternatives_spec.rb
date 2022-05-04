require 'spec_helper'

module Summary
  describe HtmlSections::Alternatives do
    let(:c100_application) { instance_double(C100Application, values) }

    subject { described_class.new(c100_application) }

    let(:values){
      {
        alternative_negotiation_tools: 'yes',
        alternative_mediation: 'yes',
        alternative_lawyer_negotiation: 'yes',
        alternative_collaborative_law: 'yes'
      }
    }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:alternatives) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(4)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:alternative_negotiation_tools)
        expect(answers[0].value).to eq('yes')
        expect(answers[0].change_path).to eq('/steps/alternatives/negotiation_tools')

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:alternative_mediation)
        expect(answers[1].value).to eq('yes')
        expect(answers[1].change_path).to eq('/steps/alternatives/mediation')

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:alternative_lawyer_negotiation)
        expect(answers[2].value).to eq('yes')
        expect(answers[2].change_path).to eq('/steps/alternatives/lawyer_negotiation')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:alternative_collaborative_law)
        expect(answers[3].value).to eq('yes')
        expect(answers[3].change_path).to eq('/steps/alternatives/collaborative_law')
      end
    end
  end
end
