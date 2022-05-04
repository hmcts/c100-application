module Steps
  module SafetyQuestions
    class DomesticAbuseController < Steps::SafetyQuestionsStepController
      def edit
        @form_object = DomesticAbuseForm.new(
          c100_application: current_c100_application,
          domestic_abuse: current_c100_application.domestic_abuse
        )
      end

      def update
        update_and_advance(DomesticAbuseForm)
      end
    end
  end
end
