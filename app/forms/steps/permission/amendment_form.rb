module Steps
  module Permission
    class AmendmentForm < QuestionForm
      include SingleQuestionForm

      yes_no_attribute :amendment,
                       reset_when_yes: [
                         :time_order,
                       ]
    end
  end
end