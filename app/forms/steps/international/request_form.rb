module Steps
  module International
    class RequestForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :international_request,
                       reset_when_no: [:international_request_details]

      attribute :international_request_details, String

      validates_presence_of :international_request_details, if: -> { international_request&.yes? }
    end
  end
end
