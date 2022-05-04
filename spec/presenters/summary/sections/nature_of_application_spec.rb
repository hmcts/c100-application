require 'spec_helper'

module Summary
  describe Sections::NatureOfApplication do
    let(:c100_application) {
      instance_double(
        C100Application,
        orders: %w(
          child_arrangements_home
          prohibited_steps_moving
          specific_issues_school
          other_issue
        ),
        orders_additional_details: 'details'
      )
    }
    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:nature_of_application)
      end
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(4)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(MultiAnswer)
        expect(answers[0].question).to eq(:child_arrangements_orders)

        expect(answers[1]).to be_an_instance_of(MultiAnswer)
        expect(answers[1].question).to eq(:prohibited_steps_orders)

        expect(answers[2]).to be_an_instance_of(MultiAnswer)
        expect(answers[2].question).to eq(:specific_issues_orders)

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:other_issue_details)
      end
    end

    context 'for a consent order' do
      let(:c100_application) {
        instance_double(C100Application, orders: %w(consent_order), orders_additional_details: nil)
      }

      it 'has the correct number of rows' do
        expect(answers.count).to eq(1)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(MultiAnswer)
        expect(answers[0].question).to eq(:formalise_arrangements)
      end
    end
  end
end
