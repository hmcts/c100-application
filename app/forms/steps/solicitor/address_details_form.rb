module Steps
  module Solicitor
    class AddressDetailsForm < AddressBaseForm
      include HasOneAssociationForm

      has_one_association :solicitor

      validates_presence_of :address_line_1, :town, :country, :postcode

      # Used to present the solicitor's name in the view
      delegate :full_name, to: :record_to_persist

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          address_values.except(:address_unknown)
        )
      end
    end
  end
end
