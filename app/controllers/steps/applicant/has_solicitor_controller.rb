module Steps
  module Applicant
    class HasSolicitorController < Steps::ApplicantStepController
      def edit
        @form_object = HasSolicitorForm.new(
          c100_application: current_c100_application,
          has_solicitor: current_c100_application.has_solicitor
        )
      end

      def update
        update_and_advance(HasSolicitorForm)
      end
    end
  end
end
