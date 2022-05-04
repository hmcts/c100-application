require 'spec_helper'

module Summary
  describe HtmlSections::MiamAttendance do
    let(:c100_application) {
      instance_double(C100Application,
        miam_certification_date: Date.new(2018, 1, 20),
        miam_certification_number: '12345',
        miam_certification_service_name: 'service name',
        miam_certification_sole_trader_name: 'sole trader name',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:miam_attendance) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(2)

        expect(answers[0]).to be_an_instance_of(DateAnswer)
        expect(answers[0].question).to eq(:miam_certification_date)
        expect(answers[0].change_path).to eq('/steps/miam/certification_date')
        expect(answers[0].value).to eq(Date.new(2018, 1, 20))

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:miam_certification_details)
        expect(answers[1].change_path).to eq('/steps/miam/certification_details')
        expect(answers[1].answers.count).to eq(3)

        ### group answers ###
        certification = answers[1].answers

        expect(certification[0]).to be_an_instance_of(FreeTextAnswer)
        expect(certification[0].question).to eq(:miam_certification_number)
        expect(certification[0].value).to eq('12345')

        expect(certification[1]).to be_an_instance_of(FreeTextAnswer)
        expect(certification[1].question).to eq(:miam_certification_service_name)
        expect(certification[1].value).to eq('service name')

        expect(certification[2]).to be_an_instance_of(FreeTextAnswer)
        expect(certification[2].question).to eq(:miam_certification_sole_trader_name)
        expect(certification[2].value).to eq('sole trader name')
      end
    end
  end
end
