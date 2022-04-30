module C100App
  class AddressLookupService
    class UnsuccessfulLookupError < StandardError; end

    ORDNANCE_SURVEY_URL = 'https://api.os.uk/search/places/v1/postcode'.freeze

    attr_reader :postcode
    attr_reader :last_exception

    def initialize(postcode)
      @postcode = postcode
    end

    def result
      @_result ||= MapAddressLookupResults.call(results)
    end

    def success?
      last_exception.nil?
    end

    def self.results_select_option(results)
      Struct.new(:results_size, :tokenized_value) do
        def address_lines
          I18n.translate!(:results, count: results_size, scope: [:steps, :shared, :address_lookup])
        end
      end.new(results.size)
    end

    private

    def query_params
      {
        key: ENV.fetch('ORDNANCE_SURVEY_API_KEY'),
        postcode: postcode,
        lr: 'EN',
      }
    end

    def results
      @_results ||= perform_lookup
    end

    def perform_lookup
      uri = URI.parse(ORDNANCE_SURVEY_URL)
      uri.query = query_params.to_query
      response = Faraday.get(uri)

      raise UnsuccessfulLookupError, response.body unless response.success?

      parse_successful_response(
        response.body
      )
    rescue StandardError => ex
      Raven.capture_exception(ex)
      @last_exception = ex
      []
    end

    def parse_successful_response(response)
      parsed_body = JSON.parse(response)

      if parsed_body.fetch('header').fetch('totalresults').positive?
        parsed_body.fetch('results')
      else
        []
      end
    end
  end
end
