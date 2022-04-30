module PersonWithAddress
  extend ActiveSupport::Concern

  ADDRESS_DATA_FIELDS = %i[
    address_line_1
    address_line_2
    address_line_3
    town
    country
    postcode
  ].freeze

  included do
    store_accessor :address_data, ADDRESS_DATA_FIELDS
  end

  def full_address
    # Ensure, no matter the order of the keys in the hash, we return the values
    # in a predictable order, matching the `store_accessor` declaration.
    address_data.symbolize_keys.values_at(
      *ADDRESS_DATA_FIELDS
    ).presence_join(', ')
  end
end
