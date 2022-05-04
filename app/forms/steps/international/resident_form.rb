module Steps
  module International
    class ResidentForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :international_resident,
                       reset_when_no: [:international_resident_details]

      attribute :international_resident_details, String

      validates_presence_of :international_resident_details, if: -> { international_resident&.yes? }
    end
  end
end
