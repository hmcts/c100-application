module Steps
  module Respondent
    class HasOtherPartiesForm < BaseForm
      include SingleQuestionForm

      # The reset will delete any associated OtherParty rows from the `people` table.
      # Because this is a `has_many` association, we nil their IDs to delete the rows.
      yes_no_attribute :has_other_parties, reset_when_no: [:other_party_ids]
    end
  end
end
