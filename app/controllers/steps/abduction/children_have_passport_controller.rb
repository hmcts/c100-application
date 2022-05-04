module Steps
  module Abduction
    class ChildrenHavePassportController < Steps::AbductionStepController
      def edit
        @form_object = ChildrenHavePassportForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(ChildrenHavePassportForm)
      end
    end
  end
end
