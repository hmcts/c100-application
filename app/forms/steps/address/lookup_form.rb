module Steps
  module Address
    class LookupForm < BaseForm
      attribute :postcode, StrippedString
      validates :postcode, presence: true, full_uk_postcode: true

      def to_partial_path
        "steps/address/lookup/#{record.type.underscore}"
      end

      private

      def changed?
        !record.postcode.eql?(postcode)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        record.update(
          postcode: postcode,
          country: lookup_default_country,
          # The following are dependent attributes that need to be reset
          address_line_1: nil,
          address_line_2: nil,
          town: nil,
        )
      end

      # We can pre-populate the country attribute so, in case the user
      # can't find the address in the list or the lookup fails, they have
      # one less input to enter (but they can change it if they need to).
      #
      def lookup_default_country
        C100App::MapAddressLookupResults::DEFAULT_COUNTRY
      end
    end
  end
end
