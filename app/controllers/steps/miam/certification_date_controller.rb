module Steps
  module Miam
    class CertificationDateController < Steps::MiamStepController
      def edit
        @form_object = CertificationDateForm.new(
          c100_application: current_c100_application,
          miam_certification_date: current_c100_application.miam_certification_date
        )
      end

      def update
        update_and_advance(CertificationDateForm, as: :miam_certification_date)
      end
    end
  end
end
