require 'spec_helper'

module Summary
  describe Sections::C1aCourtDetails do
    let(:c100_application) { instance_double(C100Application) }
    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:c1a_court_details)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(3)

        expect(answers[0]).to be_an_instance_of(Partial)
        expect(answers[0].name).to eq(:admin_court_and_case_number)

        expect(answers[1]).to be_an_instance_of(Partial)
        expect(answers[1].name).to eq(:admin_date_issued)

        expect(answers[2]).to be_an_instance_of(Partial)
        expect(answers[2].name).to eq(:admin_orders_applied_for)
      end
    end
  end
end
