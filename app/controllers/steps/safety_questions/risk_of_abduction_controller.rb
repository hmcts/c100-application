module Steps
  module SafetyQuestions
    class RiskOfAbductionController < Steps::SafetyQuestionsStepController
      def edit
        @form_object = RiskOfAbductionForm.new(
          c100_application: current_c100_application,
          risk_of_abduction: current_c100_application.risk_of_abduction
        )
      end

      def update
        update_and_advance(RiskOfAbductionForm)
      end
    end
  end
end
