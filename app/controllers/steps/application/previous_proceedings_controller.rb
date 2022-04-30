module Steps
  module Application
    class PreviousProceedingsController < Steps::ApplicationStepController
      def edit
        @form_object = PreviousProceedingsForm.new(
          c100_application: current_c100_application,
          children_previous_proceedings: current_c100_application.children_previous_proceedings
        )
      end

      def update
        update_and_advance(PreviousProceedingsForm, as: :previous_proceedings)
      end
    end
  end
end
