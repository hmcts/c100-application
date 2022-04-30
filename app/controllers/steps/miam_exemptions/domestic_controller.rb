module Steps
  module MiamExemptions
    class DomesticController < Steps::MiamExemptionsStepController
      def edit
        @form_object = DomesticForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(DomesticForm, as: :domestic)
      end
    end
  end
end
