module Steps
  module Abduction
    class PreviousAttemptForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :abduction_detail

      yes_no_attribute :previous_attempt,
                       reset_when_no: [Steps::Abduction::PreviousAttemptDetailsForm]
    end
  end
end
