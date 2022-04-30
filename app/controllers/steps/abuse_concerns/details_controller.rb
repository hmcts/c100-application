module Steps
  module AbuseConcerns
    class DetailsController < BaseAbuseStepController
      def edit
        @form_object = DetailsForm.build(
          current_concern, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(DetailsForm, as: :details)
      end
    end
  end
end
