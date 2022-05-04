require 'spec_helper'

module Summary
  describe HtmlSections::ChildrenFurtherInformation do
    let(:c100_application) {
      instance_double(C100Application,
        children_known_to_authorities: 'yes',
        children_known_to_authorities_details: 'details',
        children_protection_plan: 'no',
        has_other_children: 'yes',
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:children_further_information)
      end
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(4)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:children_known_to_authorities)
        expect(answers[0].change_path).to eq('/steps/children/additional_details')
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:children_known_to_authorities_details)
        expect(answers[1].change_path).to eq('/steps/children/additional_details')
        expect(answers[1].value).to eq('details')

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:children_protection_plan)
        expect(answers[2].change_path).to eq('/steps/children/additional_details')
        expect(answers[2].value).to eq('no')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:has_other_children)
        expect(answers[3].change_path).to eq('/steps/children/has_other_children')
        expect(answers[3].value).to eq('yes')
      end
    end
  end
end
