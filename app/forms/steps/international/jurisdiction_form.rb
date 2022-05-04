module Steps
  module International
    class JurisdictionForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :international_jurisdiction,
                       reset_when_no: [:international_jurisdiction_details]

      attribute :international_jurisdiction_details, String

      validates_presence_of :international_jurisdiction_details, if: -> { international_jurisdiction&.yes? }
    end
  end
end
