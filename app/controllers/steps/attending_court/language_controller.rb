module Steps
  module AttendingCourt
    class LanguageController < Steps::AttendingCourtStepController
      def edit
        @form_object = LanguageForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(LanguageForm, as: :language)
      end
    end
  end
end
