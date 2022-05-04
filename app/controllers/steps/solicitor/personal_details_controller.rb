module Steps
  module Solicitor
    class PersonalDetailsController < Steps::SolicitorStepController
      def edit
        @form_object = PersonalDetailsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(PersonalDetailsForm, as: :personal_details)
      end
    end
  end
end
