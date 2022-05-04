module Steps
  module SafetyQuestions
    class SubstanceAbuseForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :substance_abuse, reset_when_no: [:substance_abuse_details]

      attribute :substance_abuse_details, String

      validates_presence_of :substance_abuse_details, if: -> { substance_abuse&.yes? }
    end
  end
end
