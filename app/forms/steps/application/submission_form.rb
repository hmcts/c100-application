module Steps
  module Application
    class SubmissionForm < BaseForm
      attribute :submission_type, String
      attribute :receipt_email, NormalisedEmail

      validates_inclusion_of :submission_type, in: SubmissionType.string_values
      validates :receipt_email, email: true, allow_blank: true

      private

      def changed?
        !c100_application.submission_type.eql?(submission_type) ||
          !c100_application.receipt_email.to_s.eql?(receipt_email)
      end

      def online_submission?
        submission_type.eql?(SubmissionType::ONLINE.to_s)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        c100_application.update(
          submission_type: submission_type,
          receipt_email: (receipt_email if online_submission?),
          # The following are dependent attributes that need to be reset
          payment_type: nil,
        )
      end
    end
  end
end
