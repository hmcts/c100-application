require 'rails_helper'

describe String do
  context '#true?' do
    context 'for blank values' do
      it 'should be false for empty string' do
        expect(''.true?).to eq(false)
      end

      it 'should be false for only spaces string' do
        expect(' '.true?).to eq(false)
      end
    end

    context 'for truthy values' do
      %w(true t yes y 1).each do |value|
        it "should be true for '#{value}'" do
          expect(value.true?).to eq(true)
        end
      end
    end

    context 'for falsey values' do
      %W(false f no n 0).each do |value|
        it "should be false for '#{value}'" do
          expect(value.true?).to eq(false)
        end
      end
    end
  end
end
