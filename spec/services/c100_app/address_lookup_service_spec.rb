require 'rails_helper'

RSpec.describe C100App::AddressLookupService do
  subject(:service) { described_class.new(postcode) }

  let(:query_params) do
    {
      key: 'test-token',
      postcode: postcode,
      lr: 'EN',
    }
  end

  let(:api_request_uri) do
    uri = URI.parse(described_class::ORDNANCE_SURVEY_URL)
    uri.query = query_params.to_query
    uri
  end

  let(:postcode) { 'SW1H9AJ' }

  describe '#result' do
    before do
      allow(ENV).to receive(:fetch).with('ORDNANCE_SURVEY_API_KEY').and_return('test-token')
    end

    context 'when the lookup is successful' do
      let(:stubbed_json_body) { file_fixture('address_lookups/success.json') }

      before do
        stub_request(:get, api_request_uri)
          .to_return(status: 200, body: stubbed_json_body)
        service.result
      end

      it 'returns the collection of addresses' do
        expect(service).to be_success
        expect(service.result).to all(be_an(C100App::MapAddressLookupResults::Address))
        expect(service.result.size).to eq(3)
      end

      context 'but the response does not contain any results' do
        let(:postcode) { 'W1A1AA' }
        let(:stubbed_json_body) { file_fixture('address_lookups/no_results.json') }

        it 'has a successful outcome' do
          expect(service).to be_success
          expect(service.result).to eq([])
        end
      end

      context 'the response cannot be parsed (`header` not found)' do
        let(:postcode) { 'W1A1AA' }
        let(:stubbed_json_body) { "{\"unknown\":\"keys\"}" }

        it 'has an unsuccessful outcome' do
          expect(service).not_to be_success
          expect(service.result).to eq([])
          expect(service.last_exception).to be_a(KeyError)
        end
      end

      context 'the response cannot be parsed (`totalresults` not found)' do
        let(:postcode) { 'W1A1AA' }
        let(:stubbed_json_body) { "{\"header\":{\"foo\":\"bar\"}}" }

        it 'has an unsuccessful outcome' do
          expect(service).not_to be_success
          expect(service.result).to eq([])
          expect(service.last_exception).to be_a(KeyError)
        end
      end

      context 'the response cannot be parsed (invalid json)' do
        let(:postcode) { 'W1A1AA' }
        let(:stubbed_json_body) { 'not_json' }

        it 'has an unsuccessful outcome' do
          expect(service).not_to be_success
          expect(service.result).to eq([])
          expect(service.last_exception).to be_a(JSON::ParserError)
        end
      end
    end

    context 'when there is a problem connecting to the postcode API' do
      before do
        stub_request(:get, api_request_uri)
          .to_raise(Errno::ECONNREFUSED)
        service.result
      end

      it 'has an unsuccessful outcome' do
        expect(service).not_to be_success
        expect(service.result).to eq([])
        expect(service.last_exception).to be_a(Faraday::ConnectionFailed)
      end
    end

    context 'when the lookup service is not successful' do
      let(:stubbed_body) do
        {
          error: {
            statuscode: 400,
            message: 'No postcode parameter provided.'
          }
        }
      end

      before do
        stub_request(:get, api_request_uri)
          .to_return(status: 400, body: stubbed_body.to_json)
        service.result
      end

      it 'has an unsuccessful outcome' do
        expect(service).not_to be_success
        expect(service.result).to eq([])
        expect(service.last_exception).to be_a(C100App::AddressLookupService::UnsuccessfulLookupError)
        expect(service.last_exception.message).to eq('{"error":{"statuscode":400,"message":"No postcode parameter provided."}}')
      end
    end

    context 'capturing and sending errors to Sentry' do
      let(:exception) { StandardError.new('boom!') }

      before do
        stub_request(:get, api_request_uri).to_raise(exception)
      end

      it 'sends the error to Sentry' do
        expect(Raven).to receive(:capture_exception).with(exception)
        service.result
      end

      it 'stores the last exception' do
        service.result
        expect(service.last_exception).not_to be_nil
      end

      it 'returns an empty array' do
        expect(service.result).to eq([])
      end
    end
  end

  describe '.results_select_option' do
    subject { described_class.results_select_option(results) }

    context 'when there are no results' do
      let(:results) { [] }
      it { expect(subject.address_lines).to eq('No addresses found') }
      it { expect(subject.tokenized_value).to be_nil }
    end

    context 'when there is 1 result' do
      let(:results) { ['result'] }
      it { expect(subject.address_lines).to eq('1 address found') }
      it { expect(subject.tokenized_value).to be_nil }
    end

    context 'when there are more than 1 result' do
      let(:results) { %w(result1 result2) }
      it { expect(subject.address_lines).to eq('2 addresses found') }
      it { expect(subject.tokenized_value).to be_nil }
    end
  end
end
