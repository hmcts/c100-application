module Steps
  module Abduction
    class ChildrenHavePassportForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :abduction_detail

      yes_no_attribute :children_have_passport,
                       reset_when_no: [Steps::Abduction::PassportDetailsForm]
    end
  end
end
