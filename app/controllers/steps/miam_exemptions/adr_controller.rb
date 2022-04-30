module Steps
  module MiamExemptions
    class AdrController < Steps::MiamExemptionsStepController
      def edit
        @form_object = AdrForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(AdrForm, as: :adr)
      end
    end
  end
end
