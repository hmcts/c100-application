module Steps
  module Application
    class CourtProceedingsController < Steps::ApplicationStepController
      def edit
        @form_object = CourtProceedingsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(CourtProceedingsForm, as: :court_proceedings)
      end
    end
  end
end
