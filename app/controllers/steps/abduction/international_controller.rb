module Steps
  module Abduction
    class InternationalController < Steps::AbductionStepController
      def edit
        @form_object = InternationalForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(InternationalForm, as: :international)
      end
    end
  end
end
