module Steps
  module Children
    class HasOtherChildrenForm < BaseForm
      include SingleQuestionForm

      # The reset will delete any associated OtherChild rows from the `people` table.
      # Because this is a `has_many` association, we nil their IDs to delete the rows.
      yes_no_attribute :has_other_children, reset_when_no: [:other_child_ids]
    end
  end
end
