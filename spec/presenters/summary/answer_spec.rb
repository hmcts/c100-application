require 'spec_helper'

describe Summary::Answer do
  let(:question) {'Question?'}
  let(:value) {'Answer!'}

  subject { described_class.new(question, value) }

  describe '#to_partial_path' do
    it 'returns the correct partial path' do
      expect(subject.to_partial_path).to eq('steps/completion/shared/row')
    end
  end
end
