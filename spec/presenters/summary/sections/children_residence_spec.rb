require 'spec_helper'

module Summary
  describe Sections::ChildrenResidence do
    let(:c100_application) {
      instance_double(C100Application,
        children: [],
      )
    }

    let(:residence) { instance_double(ChildResidence) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:children_residence)
      end
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      let(:residence_finder) { double('residence_finder') }
      let(:host_people_finder) { double('host_people_finder') }

      # Lots of doubling and mocking here to avoid creating actual DB entries.
      before do
        allow(ChildResidence).to receive(:where).and_return(residence_finder)
        allow(residence_finder).to receive(:pluck).with(:person_ids).and_return([%w(12 34 56)])

        allow(Person).to receive(:where).with(id: %w(12 34 56)).and_return(host_people_finder)
        allow(host_people_finder).to receive(:pluck).with(:type).and_return(%w(Respondent Applicant Respondent))
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(1)
      end

      it 'has the correct rows in the right order' do
        expect(c100_application).to receive(:children)

        expect(answers[0]).to be_an_instance_of(MultiAnswer)
        expect(answers[0].question).to eq(:children_residence)
        expect(answers[0].value).to eq(%w(Applicant Respondent))
      end
    end
  end
end
