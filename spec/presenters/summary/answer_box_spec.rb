require 'spec_helper'

describe Summary::AnswerBox do
  let(:question) {'Question?'}

  subject { described_class.new(question) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('steps/completion/shared/answer_box') }
  end

  describe '#show?' do
    it { expect(subject.show?).to eq(true) }
  end

  describe '#value' do
    it { expect(subject.value).to be_nil }
  end
end
