require 'spec_helper'

module Summary
  describe Sections::ApplicantRespondent do
    let(:c100_application) { instance_double(C100Application, applicants: applicants, respondents: respondents) }
    subject { described_class.new(c100_application) }

    let(:applicants)  {
      [
        instance_double(Applicant, full_name: 'John'),
        instance_double(Applicant, full_name: 'Paul')
      ]
    }
    let(:respondents) {
      [
        instance_double(Respondent, full_name: 'Kate'),
        instance_double(Respondent, full_name: 'Mary')
      ]
    }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:applicant_respondent)
      end
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(2)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].value).to eq('John, Paul')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].value).to eq('Kate, Mary')
      end
    end
  end
end
