module Steps
  module Solicitor
    class AddressDetailsController < Steps::SolicitorStepController
      def edit
        @form_object = AddressDetailsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(AddressDetailsForm, as: :address_details)
      end
    end
  end
end
