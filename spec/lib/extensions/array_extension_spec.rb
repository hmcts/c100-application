require 'rails_helper'

describe Array do
  subject { described_class.new(values) }

  context '#presence_join' do
    let(:values) { ['a', nil, 'b', '', 'c', ' '] }

    context 'for a specified separator' do
      it 'returns the joined values, without blanks' do
        expect(subject.presence_join(',')).to eq('a,b,c')
      end
    end

    context 'for a nil separator' do
      it 'returns the joined values, without blanks' do
        expect(subject.presence_join).to eq('abc')
      end
    end
  end
end
