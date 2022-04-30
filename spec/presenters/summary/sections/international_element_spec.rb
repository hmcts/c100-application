require 'spec_helper'

module Summary
  describe Sections::InternationalElement do
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

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(6)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:international_resident)
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:international_resident_details)
        expect(answers[1].value).to eq('international resident details')

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:international_jurisdiction)
        expect(answers[2].value).to eq('yes')

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:international_jurisdiction_details)
        expect(answers[3].value).to eq('international jurisdiction details')

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:international_request)
        expect(answers[4].value).to eq('yes')

        expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[5].question).to eq(:international_request_details)
        expect(answers[5].value).to eq('international request details')
      end
    end

    describe "#default_value" do
      it 'is the generic NO' do
        expect(subject.send(:default_value)).to eq(GenericYesNo::NO)
      end
    end
  end
end
