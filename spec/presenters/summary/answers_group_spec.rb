require 'spec_helper'

describe Summary::AnswersGroup do
  let(:questions) { [
    question1,
    question2,
  ] }
  let(:change_path) { nil }

  let(:question1) { double('question1') }
  let(:question2) { double('question2') }

  subject { described_class.new(:group_name, questions, change_path: change_path) }

  describe '#name' do
    it { expect(subject.name).to eq(:group_name) }
  end

  describe '#to_partial_path' do
    it 'returns the correct partial path' do
      expect(subject.to_partial_path).to eq('steps/completion/shared/answers_group')
    end
  end

  describe '#answers' do
    it 'selects the answers that should be shown' do
      expect(question1).to receive(:show?).and_return(false)
      expect(question2).to receive(:show?).and_return(true)
      expect(subject.answers).to eq([question2])
    end
  end

  describe '#show?' do
    it 'returns true if there are answers to show' do
      expect(subject).to receive(:answers).and_return([question2])
      expect(subject.show?).to eq(true)
    end

    it 'returns true if there are no answers to show' do
      expect(subject).to receive(:answers).and_return([])
      expect(subject.show?).to eq(false)
    end
  end

  describe '#show_change_link?' do
    it 'returns false' do
      expect(subject.show_change_link?).to eq(false)
    end

    context 'when change_path is given' do
      let(:change_path) {'/change'}

      it 'returns true' do
        expect(subject.show_change_link?).to eq(true)
      end
    end
  end
end
