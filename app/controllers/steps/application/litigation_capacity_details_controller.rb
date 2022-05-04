module Steps
  module Application
    class LitigationCapacityDetailsController < Steps::ApplicationStepController
      def edit
        @form_object = LitigationCapacityDetailsForm.build(current_c100_application)
      end

      def update
        update_and_advance(LitigationCapacityDetailsForm, as: :litigation_capacity_details)
      end
    end
  end
end
