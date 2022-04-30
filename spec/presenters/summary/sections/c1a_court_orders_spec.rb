require 'spec_helper'

module Summary
  describe Sections::C1aCourtOrders do
    let(:c100_application) {
      instance_double(C100Application, court_order: court_order
    ) }

    # We are going to test only 1 order, no need for more, all work the same
    let(:court_order) {
      CourtOrder.new(
        restraining: GenericYesNo::YES,
        restraining_case_number: '12345678',
        restraining_issue_date: Date.new(2018, 1, 20),
        restraining_length: '1 year',
        restraining_is_current: GenericYesNo::YES,
        restraining_court_name: 'court name'
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:c1a_court_orders) }
    end

    describe '#answers' do
      # We are only testing one order (`restraining`, declared above) as all work the same,
      # but this expectation will ensure we check all the available court order types
      it 'checks all the court orders' do
        expect(court_order).to receive(:[]).with('non_molestation')
        expect(court_order).to receive(:[]).with('occupation')
        expect(court_order).to receive(:[]).with('forced_marriage_protection')
        expect(court_order).to receive(:[]).with('restraining')
        expect(court_order).to receive(:[]).with('injunctive')
        expect(court_order).to receive(:[]).with('undertaking')
        answers
      end

      it 'has the correct rows' do
        expect(answers.count).to eq(7)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:c1a_order_name)
        expect(answers[0].value).to eq('restraining')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:c1a_order_case_number)
        expect(answers[1].value).to eq('12345678')

        expect(answers[2]).to be_an_instance_of(DateAnswer)
        expect(answers[2].question).to eq(:c1a_order_issue_date)
        expect(answers[2].value).to eq(Date.new(2018, 1, 20))

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:c1a_order_length)
        expect(answers[3].value).to eq('1 year')

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:c1a_order_is_current)
        expect(answers[4].value).to eq('yes')

        expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[5].question).to eq(:c1a_order_court_name)
        expect(answers[5].value).to eq('court name')

        expect(answers[6]).to be_an_instance_of(Partial)
        expect(answers[6].name).to eq(:row_blank_space)
      end

      context 'when no court orders were made' do
        let(:court_order) { nil }

        it 'has the correct rows in the right order' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Separator)
          expect(answers[0].title).to eq(:not_applicable)
        end
      end
    end
  end
end
