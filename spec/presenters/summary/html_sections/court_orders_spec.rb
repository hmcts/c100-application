require 'spec_helper'

module Summary
  describe HtmlSections::CourtOrders do
    let(:c100_application) {
      instance_double(
        C100Application,
        has_court_orders: has_court_orders,
        court_order: court_order,
    ) }

    let(:has_court_orders) { 'yes' }

    # We are going to test only 1 order, no need for more, all work the same
    let(:court_order) {
      CourtOrder.new(
        restraining: 'yes',
        restraining_case_number: '12345678',
        restraining_issue_date: Date.new(2018, 1, 20),
        restraining_length: '1 year',
        restraining_is_current: 'yes',
        restraining_court_name: 'court name'
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:court_orders) }
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
        expect(answers.count).to eq(2)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:has_court_orders)
        expect(answers[0].change_path).to eq('/steps/court_orders/has_orders')
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:court_orders_details)
        expect(answers[1].change_path).to eq('/steps/court_orders/details')
        expect(answers[1].answers.count).to eq(6)

          ## court_orders details group answers ###
          details = answers[1].answers

          expect(details[0]).to be_an_instance_of(Answer)
          expect(details[0].question).to eq(:order_name)
          expect(details[0].value).to eq('restraining')

          expect(details[1]).to be_an_instance_of(FreeTextAnswer)
          expect(details[1].question).to eq(:order_case_number)
          expect(details[1].value).to eq('12345678')

          expect(details[2]).to be_an_instance_of(DateAnswer)
          expect(details[2].question).to eq(:order_issue_date)
          expect(details[2].value).to eq(Date.new(2018, 1, 20))

          expect(details[3]).to be_an_instance_of(FreeTextAnswer)
          expect(details[3].question).to eq(:order_length)
          expect(details[3].value).to eq('1 year')

          expect(details[4]).to be_an_instance_of(Answer)
          expect(details[4].question).to eq(:order_is_current)
          expect(details[4].value).to eq('yes')

          expect(details[5]).to be_an_instance_of(FreeTextAnswer)
          expect(details[5].question).to eq(:order_court_name)
          expect(details[5].value).to eq('court name')
      end

      context 'when no court orders were made' do
        let(:has_court_orders) { 'no' }
        let(:court_order) { nil }

        it 'has the correct rows in the right order' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:has_court_orders)
          expect(answers[0].change_path).to eq('/steps/court_orders/has_orders')
          expect(answers[0].value).to eq('no')
        end
      end
    end
  end
end
