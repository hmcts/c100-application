require 'spec_helper'

module Summary
  describe Sections::OtherCourtCases do
    let(:c100_application) {
      instance_double(C100Application,
        children_previous_proceedings: children_previous_proceedings,
        court_proceeding: court_proceeding,
    ) }

    let(:court_proceeding) {
      instance_double(CourtProceeding,
        children_names: 'children_names',
        court_name: 'court_name',
        case_number: 'case_number',
        proceedings_date: 'proceedings_date',
        cafcass_details: 'cafcass_details',
        order_types: 'order_types',
        previous_details: 'previous_details',
    ) }

    let(:children_previous_proceedings) { 'yes' }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:other_court_cases) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(7)

        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].question).to eq(:court_proceeding_children_names)
        expect(answers[0].value).to eq('children_names')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:court_proceeding_court_name)
        expect(answers[1].value).to eq('court_name')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:court_proceeding_case_number)
        expect(answers[2].value).to eq('case_number')

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:court_proceeding_proceedings_date)
        expect(answers[3].value).to eq('proceedings_date')

        expect(answers[4]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[4].question).to eq(:court_proceeding_cafcass_details)
        expect(answers[4].value).to eq('cafcass_details')

        expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[5].question).to eq(:court_proceeding_order_types)
        expect(answers[5].value).to eq('order_types')

        expect(answers[6]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[6].question).to eq(:court_proceeding_previous_details)
        expect(answers[6].value).to eq('previous_details')
      end

      context 'when there are no previous proceeding details' do
        let(:court_proceeding) { nil }

        it 'has the correct rows' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Separator)
          expect(answers[0].title).to eq(:not_applicable)
        end
      end
    end
  end
end
