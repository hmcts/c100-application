module Steps
  module Children
    class AdditionalDetailsController < Steps::ChildrenStepController
      def edit
        @form_object = AdditionalDetailsForm.build(current_c100_application)
      end

      def update
        update_and_advance(AdditionalDetailsForm, as: :additional_details)
      end
    end
  end
end
