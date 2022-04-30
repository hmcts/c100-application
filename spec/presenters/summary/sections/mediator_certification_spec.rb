require 'spec_helper'

module Summary
  describe Sections::MediatorCertification do
    let(:c100_application) {
      instance_double(C100Application,
        miam_certification: miam_certification,
        miam_certification_number: miam_certification_number,
        miam_certification_date: miam_certification_date,
        miam_certification_service_name: miam_certification_service_name,
        miam_certification_sole_trader_name: miam_certification_sole_trader_name,
    ) }

    let(:miam_certification) { 'yes' }
    let(:miam_certification_number) { '12345-X' }
    let(:miam_certification_service_name) { 'service name' }
    let(:miam_certification_sole_trader_name) { 'trader name' }
    let(:miam_certification_date) { Date.new(2018, 1, 20) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:mediator_certification) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(5)

        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].question).to eq(:miam_certification_number)
        expect(c100_application).to have_received(:miam_certification_number)

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:miam_certification_service_name)
        expect(c100_application).to have_received(:miam_certification_service_name)

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:miam_certification_sole_trader_name)
        expect(c100_application).to have_received(:miam_certification_sole_trader_name)

        expect(answers[3]).to be_an_instance_of(DateAnswer)
        expect(answers[3].question).to eq(:miam_certification_date)
        expect(c100_application).to have_received(:miam_certification_date)

        expect(answers[4]).to be_an_instance_of(Separator)
        expect(answers[4].title).to eq(:hmcts_instructions)
      end

      context 'when no certification received' do
        let(:miam_certification) { 'no' }

        it 'has the correct rows' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Separator)
          expect(answers[0].title).to eq(:not_applicable)
        end
      end
    end
  end
end
