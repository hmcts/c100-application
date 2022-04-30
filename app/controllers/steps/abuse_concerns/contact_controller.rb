module Steps
  module AbuseConcerns
    class ContactController < Steps::AbuseConcernsStepController
      def edit
        @form_object = ContactForm.new(
          c100_application: current_c100_application,
          concerns_contact_type: current_c100_application.concerns_contact_type,
          concerns_contact_other: current_c100_application.concerns_contact_other
        )
      end

      def update
        update_and_advance(ContactForm, as: :contact)
      end
    end
  end
end
