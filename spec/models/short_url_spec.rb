require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  subject { described_class.new({path: 'test'}.merge(config)) }

  let(:config) { {} }

  describe '#to_str' do
    context 'with custom `target_url`' do
      let(:config) { {target_url: 'http://example.com'} }
      it { expect(subject.to_str).to eq('http://example.com') }
    end

    context 'with custom `target_path`' do
      let(:config) { {target_path: '/xyz'} }
      it { expect(subject.to_str).to eq('/xyz') }
    end

    context 'with custom `target_url` and `target_path`' do
      let(:config) { {target_url: 'http://example.com', target_path: '/xyz'} }
      it { expect(subject.to_str).to eq('http://example.com/xyz') }
    end

    describe 'utm tracking params' do
      context '`utm_source`' do
        let(:config) { {utm_source: 'source'} }
        it { expect(subject.to_str).to eq('?utm_source=source') }
      end

      context '`utm_medium`' do
        let(:config) { {utm_medium: 'medium'} }
        it { expect(subject.to_str).to eq('?utm_medium=medium') }
      end

      context '`utm_campaign`' do
        let(:config) { {utm_campaign: 'campaign'} }
        it { expect(subject.to_str).to eq('?utm_campaign=campaign') }
      end

      context 'multiple utm params' do
        let(:config) { {utm_source: 'source', utm_medium: 'medium'} }
        it { expect(subject.to_str).to eq('?utm_medium=medium&utm_source=source') }
      end
    end

    context 'complete URL with tracking' do
      let(:config) { {target_url: 'http://example.com', target_path: '/xyz', utm_source: 'source'} }
      it { expect(subject.to_str).to eq('http://example.com/xyz?utm_source=source') }
    end
  end

  describe '.resolve' do
    before do
      ShortUrl.create(path: 'xyz', target_url: target_url)
    end

    after do
      ShortUrl.delete_all
    end

    let(:path) { nil }
    let(:target_url) { nil }

    let(:short_url) { ShortUrl.find(path) }
    let(:resolved_url) { described_class.resolve(path: path, target_url: 'http://example.com') }

    context 'for an existing path' do
      let(:path) { 'xyz' }

      it 'increases the visits counter' do
        expect {
          resolved_url
        }.to change { short_url.reload.visits }.by(1)
      end

      it 'returns the found URL' do
        expect(described_class).not_to receive(:new)
        expect(resolved_url).to eq(short_url)
      end

      context 'blank target_url' do
        it 'defaults to the provided target_url' do
          expect(resolved_url.target_url).to eq('http://example.com')
        end
      end

      context 'existing target_url' do
        let(:target_url) { 'http://test.com' }

        it 'uses the existing `target_url` if present' do
          expect(resolved_url.target_url).to eq('http://test.com')
        end
      end
    end

    context 'for a non existent path' do
      let(:path) { 'foobar' }

      it 'initialises a new short URL' do
        expect(described_class).to receive(:new).with(path: 'foobar').and_call_original
        resolved_url
      end

      it 'does not increase the visits counter' do
        expect(resolved_url.visits).to eq(0)
      end
    end
  end
end
