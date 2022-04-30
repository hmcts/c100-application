module Steps
  module Alternatives
    class MediationController < Steps::AlternativesStepController
      def edit
        @form_object = MediationForm.build(current_c100_application)
      end

      def update
        update_and_advance(MediationForm, as: :mediation)
      end
    end
  end
end
