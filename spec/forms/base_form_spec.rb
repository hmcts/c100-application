require 'spec_helper'

RSpec.describe BaseForm do
  describe '#persisted?' do
    it 'always returns false' do
      expect(subject.persisted?).to eq(false)
    end
  end

  describe '#new_record?' do
    it 'always returns true' do
      expect(subject.new_record?).to eq(true)
    end
  end

  describe '#to_key' do
    it 'always returns nil' do
      expect(subject.to_key).to be_nil
    end
  end

  describe '#save!' do
    context 'when raising exceptions' do
      it {
        expect(subject).to receive(:persist!).and_raise(NoMethodError)
        expect(subject.save!).to eq(false)
      }
    end

    context 'when there are no exceptions' do
      it {
        expect(subject).to receive(:persist!).and_return(true)
        expect(subject.save!).to eq(true)
      }
    end
  end

  describe '[]' do
    let(:c100_application) { instance_double(C100Application) }

    before do
      subject.c100_application = c100_application
    end

    it 'read the attribute directly without using the method' do
      expect(subject).not_to receive(:c100_application)
      expect(subject[:c100_application]).to eq(c100_application)
    end
  end

  describe '[]=' do
    let(:c100_application) { instance_double(C100Application) }

    it 'assigns the attribute directly without using the method' do
      expect(subject).not_to receive(:c100_application=)
      subject[:c100_application] = c100_application
      expect(subject.c100_application).to eq(c100_application)
    end
  end

  describe '.attributes' do
    it 'defines individual attributes given a collection' do
      expect(described_class).to receive(:attribute).with(:a, String, default: 'test')
      expect(described_class).to receive(:attribute).with(:b, String, default: 'test')

      described_class.attributes([:a, :b], String, default: 'test')
    end
  end
end
