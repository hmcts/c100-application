module Steps
  module SafetyQuestions
    class DomesticAbuseForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :domestic_abuse
    end
  end
end
