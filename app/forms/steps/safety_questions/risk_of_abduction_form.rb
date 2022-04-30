module Steps
  module SafetyQuestions
    class RiskOfAbductionForm < BaseForm
      include SingleQuestionForm

      # The reset will delete the row from the `abduction_details` table
      yes_no_attribute :risk_of_abduction, reset_when_no: [:abduction_detail]
    end
  end
end
