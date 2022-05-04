require 'rails_helper'

RSpec.describe GenericYesNoUnknown do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(yes no unknown))
    end
  end

  describe '#yes?' do
    context 'when value is `yes`' do
      let(:value) { :yes }
      it { expect(subject.yes?).to eq(true) }
    end

    context 'when value is not `yes`' do
      let(:value) { :no }
      it { expect(subject.yes?).to eq(false) }
    end
  end

  describe '#no?' do
    context 'when value is `no`' do
      let(:value) { :no }
      it { expect(subject.no?).to eq(true) }
    end

    context 'when value is not `no`' do
      let(:value) { :yes }
      it { expect(subject.no?).to eq(false) }
    end
  end

  describe '#unknown?' do
    context 'when value is `unknown`' do
      let(:value) { :unknown }
      it { expect(subject.unknown?).to eq(true) }
    end

    context 'when value is not `unknown`' do
      let(:value) { :yes }
      it { expect(subject.unknown?).to eq(false) }
    end
  end
end
