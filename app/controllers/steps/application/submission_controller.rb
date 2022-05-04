module Steps
  module Application
    class SubmissionController < Steps::ApplicationStepController
      def edit
        @form_object = SubmissionForm.build(current_c100_application)
      end

      def update
        update_and_advance(SubmissionForm, as: :submission)
      end
    end
  end
end
