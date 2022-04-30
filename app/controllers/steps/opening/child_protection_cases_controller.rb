module Steps
  module Opening
    class ChildProtectionCasesController < Steps::OpeningStepController
      def edit
        @form_object = ChildProtectionCasesForm.new(
          c100_application: current_c100_application,
          child_protection_cases: current_c100_application.child_protection_cases
        )
      end

      def update
        update_and_advance(ChildProtectionCasesForm)
      end
    end
  end
end
