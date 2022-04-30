module Steps
  module Applicant
    class HasSolicitorForm < BaseForm
      include SingleQuestionForm

      # The reset will delete the row from the `solicitors` table and the `payment_type` attrib,
      # just in case they got this far and selected fee account (which only works for solicitors).
      yes_no_attribute :has_solicitor, reset_when_no: [:solicitor, :payment_type]
    end
  end
end
