require 'rails_helper'

describe ShortUrlExpander do
  let(:request) { spy('request') }

  subject { described_class.new('http://test.com') }

  describe '#call' do
    context '`params` contains the `path`' do
      let(:params) { {path: 'xyz'} }

      it 'calls the resolver with the value of `path`' do
        expect(ShortUrl).to receive(:resolve).with(path: 'xyz', target_url: 'http://test.com')
        subject.call(params, request)
      end
    end

    context '`params` does not contain the `path`' do
      let(:params) { {} }

      it 'calls the resolver with `path` nil' do
        expect(ShortUrl).to receive(:resolve).with(path: nil, target_url: 'http://test.com')
        subject.call(params, request)
      end
    end
  end
end
