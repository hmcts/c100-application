require 'spec_helper'

module Summary
  describe Sections::C8CourtDetails do
    let(:c100_application) { instance_double(C100Application, children: [child]) }
    subject { described_class.new(c100_application) }

    let(:child) { instance_double(Child, full_name: 'John Doe') }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:c8_court_details)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(4)

        expect(answers[0]).to be_an_instance_of(Partial)
        expect(answers[0].name).to eq(:admin_court_and_case_number)

        expect(answers[1]).to be_an_instance_of(Partial)
        expect(answers[1].name).to eq(:row_blank_space)

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:c8_children_names)
        expect(answers[2].value).to eq(:c8_children_numbers)

        expect(answers[3]).to be_an_instance_of(AnswerBox)
        expect(answers[3].question).to eq('John Doe')
      end
    end
  end
end
