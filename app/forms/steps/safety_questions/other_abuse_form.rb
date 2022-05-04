module Steps
  module SafetyQuestions
    class OtherAbuseForm < BaseForm
      include SingleQuestionForm

      # The applicant can only reach this step if all previous safety questions
      # were answered `no`. If they also answer `no` to this one, then we delete
      # any C1A questions that might have been answered previously.

      # The reset will delete any associated rows from the `abuse_concerns` table.
      # Because this is a `has_many` association, we nil their IDs to delete the rows.
      # It will also delete the row from the `court_orders` table.
      yes_no_attribute :other_abuse, reset_when_no: [
        :abuse_concern_ids,
        :has_court_orders,
        :court_order,
        Steps::AbuseConcerns::ContactForm,
        Steps::Petition::ProtectionForm,
      ]
    end
  end
end
