module Steps
  module Address
    class LookupController < Steps::AddressStepController
      def edit
        @form_object = LookupForm.new(
          c100_application: current_c100_application,
          record: current_record,
          postcode: current_record.postcode,
        )
      end

      def update
        update_and_advance(
          LookupForm,
          record: current_record,
          as: :postcode_lookup
        )
      end
    end
  end
end
