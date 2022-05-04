module Steps
  module Miam
    class MediatorExemptionController < Steps::MiamStepController
      def edit
        @form_object = MediatorExemptionForm.new(
          c100_application: current_c100_application,
          miam_mediator_exemption: current_c100_application.miam_mediator_exemption
        )
      end

      def update
        update_and_advance(MediatorExemptionForm)
      end
    end
  end
end
