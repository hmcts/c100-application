module Steps
  module SafetyQuestions
    class ChildrenAbuseForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :children_abuse
    end
  end
end
