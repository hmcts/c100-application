module C100App
  class MapAddressLookupResults
    LINE_ONE_PARTS = %w[SUB_BUILDING_NAME BUILDING_NUMBER BUILDING_NAME DEPARTMENT_NAME ORGANISATION_NAME].freeze
    LINE_TWO_PARTS = %w[DEPENDENT_THOROUGHFARE_NAME THOROUGHFARE_NAME].freeze
    DEFAULT_COUNTRY = 'UNITED KINGDOM'.freeze
    OTHER_COUNTRIES = ['ISLE OF MAN', 'JERSEY', 'GUERNSEY'].freeze

    Address = Struct.new(:address_line_1, :address_line_2, :address_line_3, :town, :country, :postcode) do
      def address_lines
        [address_line_1, address_line_2].presence_join(', ')
      end

      def tokenized_value
        values.join('|')
      end
    end

    def self.call(results)
      results.map do |result|
        map_to_address(result.fetch('DPA'))
      end
    end

    def self.map_to_address(result)
      Address.new(
        address_line(result.slice(*LINE_ONE_PARTS).values),
        address_line(result.slice(*LINE_TWO_PARTS).values),
        "",
        postal_town(result),
        country_name(result),
        result.fetch('POSTCODE')
      )
    end

    def self.postal_town(result)
      return result.fetch('DEPENDENT_LOCALITY') if OTHER_COUNTRIES.include?(result.fetch('POST_TOWN'))
      result.fetch('POST_TOWN')
    end

    def self.country_name(result)
      return result.fetch('POST_TOWN') if OTHER_COUNTRIES.include?(result.fetch('POST_TOWN'))
      DEFAULT_COUNTRY
    end

    def self.address_line(values)
      values.presence_join(', ')
    end
  end
end
