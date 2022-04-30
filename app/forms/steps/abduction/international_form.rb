module Steps
  module Abduction
    class InternationalForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :abduction_detail
      yes_no_attribute :passport_office_notified
    end
  end
end
