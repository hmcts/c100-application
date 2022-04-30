module Steps
  module Applicant
    class AddressDetailsController < Steps::ApplicantStepController
      def edit
        @form_object = AddressDetailsForm.build(
          current_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          AddressDetailsForm,
          record: current_record,
          as: :address_details
        )
      end
    end
  end
end
