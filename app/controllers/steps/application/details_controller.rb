module Steps
  module Application
    class DetailsController < Steps::ApplicationStepController
      def edit
        @form_object = DetailsForm.new(
          c100_application: current_c100_application,
          application_details: current_c100_application.application_details
        )
      end

      def update
        update_and_advance(DetailsForm)
      end
    end
  end
end
