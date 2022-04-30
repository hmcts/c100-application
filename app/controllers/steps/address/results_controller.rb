module Steps
  module Address
    class ResultsController < Steps::AddressStepController
      before_action :retrieve_addresses

      def edit
        @form_object = ResultsForm.new(
          c100_application: current_c100_application,
          record: current_record,
        )
      end

      def update
        update_and_advance(
          ResultsForm,
          record: current_record,
          as: :address_selection
        )
      end

      private

      def retrieve_addresses
        @addresses = lookup_service.result
        @successful_lookup = lookup_service.success?
      end

      def lookup_service
        @_lookup_service ||= C100App::AddressLookupService.new(
          current_record.postcode
        )
      end
    end
  end
end
