require 'rails_helper'

RSpec.describe C100App::AbuseConcernsDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      {
    {
      'subject': abuse_subject,
      'kind': abuse_kind,
      'answer': abuse_answer
    }
  }
  let(:next_step)        { nil }
  let(:as)               { 'question' }

  let(:abuse_subject)    { 'applicant' }
  let(:abuse_kind)       { 'physical' }
  let(:abuse_answer)     { 'no' }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  # BEGIN - Mutant killers
  it 'retrieve the subject from the `step_params`' do
    expect(subject.step_params).to receive(:[]).with(:subject).and_return(:applicant)
    expect(subject).to receive(:applicant_questions_destination)
    subject.destination
  end

  it 'retrieve the abuse kind from the `step_params`' do
    expect(subject.step_params).to receive(:[]).with(:kind).and_return(:other)
    allow(subject).to receive(:abuse_subject).and_return(AbuseSubject::APPLICANT)
    allow(subject).to receive(:abuse_answer).and_return(GenericYesNo::NO)
    subject.destination
  end

  it 'retrieve the answer from the `step_params`' do
    expect(subject.step_params).to receive(:[]).with(:answer).and_return(:yes)
    allow(subject).to receive(:abuse_subject).and_return(AbuseSubject::APPLICANT)
    allow(subject).to receive(:abuse_kind).and_return(AbuseType::PHYSICAL)
    subject.destination
  end
  # END - Mutant killers

  describe 'when the step is `question`' do
    let(:as) { 'question' }

    context 'when answer is `no`' do
      let(:abuse_answer) { 'no' }

      context 'when the subject is `applicant`' do
        let(:abuse_subject) { 'applicant' }

        context 'when the abuse kind is invalid' do
          let(:abuse_kind) { 'foobar' }

          it 'raises an error' do
            expect { subject.destination }.to raise_error(
              BaseDecisionTree::InvalidStep, 'Unknown abuse kind: foobar'
            )
          end
        end

        context 'abuse kind `physical`' do
          let(:abuse_kind) { 'physical' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'financial'})}
        end

        context 'abuse kind `emotional`' do
          let(:abuse_kind) { 'emotional' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'other'})}
        end

        context 'abuse kind `psychological`' do
          let(:abuse_kind) { 'psychological' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'emotional'})}
        end

        context 'abuse kind `sexual`' do
          let(:abuse_kind) { 'sexual' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'physical'})}
        end

        context 'abuse kind `financial`' do
          let(:abuse_kind) { 'financial' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'psychological'})}
        end

        context 'abuse kind `other`' do
          let(:abuse_kind) { 'other' }
          it {is_expected.to have_destination('/steps/court_orders/has_orders', :edit)}
        end
      end

      context 'when the subject is `children`' do
        let(:abuse_subject) { 'children' }

        context 'when the abuse kind is invalid' do
          let(:abuse_kind) { 'foobar' }

          it 'raises an error' do
            expect { subject.destination }.to raise_error(
              BaseDecisionTree::InvalidStep, 'Unknown abuse kind: foobar'
            )
          end
        end

        context 'abuse kind `physical`' do
          let(:abuse_kind) { 'physical' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'financial'})}
        end

        context 'abuse kind `emotional`' do
          let(:abuse_kind) { 'emotional' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'other'})}
        end

        context 'abuse kind `psychological`' do
          let(:abuse_kind) { 'psychological' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'emotional'})}
        end

        context 'abuse kind `sexual`' do
          let(:abuse_kind) { 'sexual' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'physical'})}
        end

        context 'abuse kind `financial`' do
          let(:abuse_kind) { 'financial' }
          it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'psychological'})}
        end

        context 'abuse kind `other`' do
          let(:abuse_kind) { 'other' }
          it {is_expected.to have_destination(:applicant_info, :show)}
        end
      end
    end

    context 'when answer is `yes`' do
      let(:abuse_answer) { 'yes' }

      context 'when the subject is `applicant`' do
        let(:abuse_subject) { 'applicant' }

        context 'abuse kind `physical`' do
          let(:abuse_kind) { 'physical' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'applicant', kind: 'physical'})}
        end

        context 'abuse kind `emotional`' do
          let(:abuse_kind) { 'emotional' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'applicant', kind: 'emotional'})}
        end

        context 'abuse kind `psychological`' do
          let(:abuse_kind) { 'psychological' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'applicant', kind: 'psychological'})}
        end

        context 'abuse kind `sexual`' do
          let(:abuse_kind) { 'sexual' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'applicant', kind: 'sexual'})}
        end

        context 'abuse kind `financial`' do
          let(:abuse_kind) { 'financial' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'applicant', kind: 'financial'})}
        end

        context 'abuse kind `other`' do
          let(:abuse_kind) { 'other' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'applicant', kind: 'other'})}
        end
      end

      context 'when the subject is `children`' do
        let(:abuse_subject) { 'children' }

        context 'abuse kind `physical`' do
          let(:abuse_kind) { 'physical' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'children', kind: 'physical'})}
        end

        context 'abuse kind `emotional`' do
          let(:abuse_kind) { 'emotional' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'children', kind: 'emotional'})}
        end

        context 'abuse kind `psychological`' do
          let(:abuse_kind) { 'psychological' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'children', kind: 'psychological'})}
        end

        context 'abuse kind `sexual`' do
          let(:abuse_kind) { 'sexual' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'children', kind: 'sexual'})}
        end

        context 'abuse kind `financial`' do
          let(:abuse_kind) { 'financial' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'children', kind: 'financial'})}
        end

        context 'abuse kind `other`' do
          let(:abuse_kind) { 'other' }
          it {is_expected.to have_destination(:details, :edit, {subject: 'children', kind: 'other'})}
        end
      end
    end
  end

  describe 'when the step is `details`' do
    let(:as) { 'details' }

    context 'when the subject is `applicant`' do
      let(:abuse_subject) { 'applicant' }

      context 'when the abuse kind is invalid' do
        let(:abuse_kind) { 'foobar' }

        it 'raises an error' do
          expect { subject.destination }.to raise_error(
            BaseDecisionTree::InvalidStep, 'Unknown abuse kind: foobar'
          )
        end
      end

      context 'abuse kind `physical`' do
        let(:abuse_kind) { 'physical' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'financial'})}
      end

      context 'abuse kind `emotional`' do
        let(:abuse_kind) { 'emotional' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'other'})}
      end

      context 'abuse kind `psychological`' do
        let(:abuse_kind) { 'psychological' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'emotional'})}
      end

      context 'abuse kind `sexual`' do
        let(:abuse_kind) { 'sexual' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'physical'})}
      end

      context 'abuse kind `financial`' do
        let(:abuse_kind) { 'financial' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'applicant', kind: 'psychological'})}
      end

      context 'abuse kind `other`' do
        let(:abuse_kind) { 'other' }
        it {is_expected.to have_destination('/steps/court_orders/has_orders', :edit)}
      end
    end

    context 'when the subject is `children`' do
      let(:abuse_subject) { 'children' }

      context 'when the abuse kind is invalid' do
        let(:abuse_kind) { 'foobar' }

        it 'raises an error' do
          expect { subject.destination }.to raise_error(
            BaseDecisionTree::InvalidStep, 'Unknown abuse kind: foobar'
          )
        end
      end

      context 'abuse kind `physical`' do
        let(:abuse_kind) { 'physical' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'financial'})}
      end

      context 'abuse kind `emotional`' do
        let(:abuse_kind) { 'emotional' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'other'})}
      end

      context 'abuse kind `psychological`' do
        let(:abuse_kind) { 'psychological' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'emotional'})}
      end

      context 'abuse kind `sexual`' do
        let(:abuse_kind) { 'sexual' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'physical'})}
      end

      context 'abuse kind `financial`' do
        let(:abuse_kind) { 'financial' }
        it {is_expected.to have_destination(:question, :edit, {subject: 'children', kind: 'psychological'})}
      end

      context 'abuse kind `other`' do
        let(:abuse_kind) { 'other' }
        it {is_expected.to have_destination(:applicant_info, :show)}
      end
    end
  end

  context 'when the step is `contact`' do
    let(:as) { 'contact' }
    it { is_expected.to have_destination('/steps/petition/orders', :edit) }
  end

  describe 'when the step is not known' do
    let(:as) { 'anything' }

    it 'raises an error' do
      expect { subject.destination }.to raise_error(
        BaseDecisionTree::InvalidStep, "Invalid step 'anything'"
      )
    end
  end
end
