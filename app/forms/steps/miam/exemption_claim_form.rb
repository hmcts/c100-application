module Steps
  module Miam
    class ExemptionClaimForm < BaseForm
      include SingleQuestionForm

      # The reset will delete the row from the `miam_exemptions` table
      yes_no_attribute :miam_exemption_claim, reset_when_no: [:miam_exemption]
    end
  end
end
