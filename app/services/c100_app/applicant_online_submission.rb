module C100App
  class ApplicantOnlineSubmission < BaseOnlineSubmission
    def process
      deliver_email && audit_data
    end

    def to_address
      c100_application.receipt_email
    end

    private

    # We use `deliver_now` here, as we want the actions performed in
    # the `process` method to be executed sequentially and the whole job
    # to fail and be retried in case any of the actions fail.
    #
    def deliver_email
      NotifySubmissionMailer.with(application_details).application_to_user(
        to_address: to_address
      ).deliver_now
    end

    def audit_data
      c100_application.email_submission.update(
        email_copy_to: to_address, user_copy_sent_at: Time.current
      )
    end
  end
end
