module Steps
  module AttendingCourt
    class IntermediaryForm < BaseForm
      include SingleQuestionForm
      include HasOneAssociationForm

      has_one_association :court_arrangement
      yes_no_attribute :intermediary_help, reset_when_no: [:intermediary_help_details]

      attribute :intermediary_help_details, String

      validates_presence_of :intermediary_help_details, if: -> { intermediary_help&.yes? }
    end
  end
end
