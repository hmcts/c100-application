require 'spec_helper'

module Summary
  describe Sections::C1aProtectionOrders do
    let(:c100_application) {
      instance_double(
        C100Application,
        protection_orders_details: 'details',
        concerns_contact_type: 'supervised',
        concerns_contact_other: 'no',
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:c1a_protection_orders) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(3)

        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].question).to eq(:c1a_protection_orders)
        expect(answers[0].value).to eq('details')

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:c1a_contact_type)
        expect(answers[1].value).to eq('supervised')

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:c1a_contact_other)
        expect(answers[2].value).to eq('no')
      end
    end
  end
end
