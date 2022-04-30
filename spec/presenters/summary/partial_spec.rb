require 'spec_helper'

describe Summary::Partial do
  let(:name) { 'anything' }

  subject { described_class.new(name) }

  describe '#ivar' do
    context 'it can be initialized with an optional instance variable' do
      subject { described_class.new(name, 'test') }
      it { expect(subject.ivar).to eq('test') }
    end
  end

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('steps/completion/shared/anything') }
  end

  describe '#show?' do
    it { expect(subject.show?).to eq(true) }
  end

  describe '.page_break' do
    it 'instantiate a Partial object with a specific partial name' do
      partial = described_class.page_break
      expect(partial.name).to eq(:page_break)
    end
  end

  describe '.blank_page' do
    it 'instantiate a Partial object with a specific partial name' do
      partial = described_class.blank_page
      expect(partial.name).to eq(:blank_page)
    end
  end

  describe '.row_blank_space' do
    it 'instantiate a Partial object with a specific partial name' do
      partial = described_class.row_blank_space
      expect(partial.name).to eq(:row_blank_space)
    end
  end

  describe '.horizontal_rule' do
    it 'instantiate a Partial object with a specific partial name' do
      partial = described_class.horizontal_rule
      expect(partial.name).to eq(:horizontal_rule)
    end
  end
end
