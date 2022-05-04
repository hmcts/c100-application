module Steps
  module SafetyQuestions
    class AddressConfidentialityForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :address_confidentiality
    end
  end
end
