module Steps
  module Miam
    class CertificationDetailsController < Steps::MiamStepController
      def edit
        @form_object = CertificationDetailsForm.build(current_c100_application)
      end

      def update
        update_and_advance(CertificationDetailsForm, as: :miam_certification_details)
      end
    end
  end
end
