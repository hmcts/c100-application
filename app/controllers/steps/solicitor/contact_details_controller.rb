module Steps
  module Solicitor
    class ContactDetailsController < Steps::SolicitorStepController
      def edit
        @form_object = ContactDetailsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(ContactDetailsForm, as: :contact_details)
      end
    end
  end
end
