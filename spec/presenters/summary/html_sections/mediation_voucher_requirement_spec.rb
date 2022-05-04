require 'spec_helper'

module Summary
  describe HtmlSections::MediationVoucherRequirement do
    let(:c100_application) {
      instance_double(C100Application,
        mediation_voucher_scheme: 'yes',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:mediation_voucher) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(1)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:mediation_voucher_scheme)
        expect(answers[0].change_path).to eq('/steps/miam/acknowledgement')
        expect(answers[0].value).to eq('yes')
      end
    end
  end
end
