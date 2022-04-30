require 'spec_helper'

module Summary
  describe Sections::C1aChildrenAbuseSummary do
    let(:c100_application) { instance_double(C100Application, abuse_concerns: abuse_concerns_resultset) }
    let(:abuse_concerns_resultset) { double('abuse_concerns_resultset').as_null_object }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:c1a_children_abuse_summary)
      end
    end

    def check_finder_received(kind)
      expect(
        abuse_concerns_resultset
      ).to have_received(:find_by).with(
        subject: AbuseSubject::CHILDREN, kind: kind
      )
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(5)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:c1a_abuse_physical)
        check_finder_received(AbuseType::PHYSICAL)

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:c1a_abuse_emotional)
        check_finder_received(AbuseType::EMOTIONAL)

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:c1a_abuse_psychological)
        check_finder_received(AbuseType::PSYCHOLOGICAL)

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:c1a_abuse_sexual)
        check_finder_received(AbuseType::SEXUAL)

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:c1a_abuse_financial)
        check_finder_received(AbuseType::FINANCIAL)
      end

      context 'defaults to `NO` when abuse concern was not found' do
        before do
          allow(abuse_concerns_resultset).to receive(:find_by).and_return(nil)
        end

        it 'has the correct rows in the right order' do
          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:c1a_abuse_physical)
          expect(answers[0].value).to eq(GenericYesNo::NO)
        end
      end
    end
  end
end
