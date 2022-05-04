module C100App
  class CourtOnlineSubmission < BaseOnlineSubmission
    def process
      generate_documents && deliver_email && audit_data
    end

    def to_address
      c100_application.court.documents_email
    end

    private

    def generate_documents
      documents.store(:bundle,  generate_pdf(:c100, :c1a))
      documents.store(:c8_form, generate_pdf(:c8))
    end

    # We use `deliver_now` here, as we want the actions performed in
    # the `process` method to be executed sequentially and the whole job
    # to fail and be retried in case any of the actions fail.
    #
    def deliver_email
      NotifySubmissionMailer.with(application_details).application_to_court(
        to_address: to_address
      ).deliver_now
    end

    def audit_data
      c100_application.email_submission.update(
        to_address: to_address, sent_at: Time.current
      )
    end
  end
end
