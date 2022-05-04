module Steps
  module Miam
    class CertificationController < Steps::MiamStepController
      def edit
        @form_object = CertificationForm.new(
          c100_application: current_c100_application,
          miam_certification: current_c100_application.miam_certification
        )
      end

      def update
        update_and_advance(CertificationForm)
      end
    end
  end
end
