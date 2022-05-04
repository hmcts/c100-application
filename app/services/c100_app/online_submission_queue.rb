module C100App
  class OnlineSubmissionQueue
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def process
      # Do not process again if we have a DB record, to avoid duplicating emails
      return unless ready_to_process

      CourtDeliveryJob.perform_later(c100_application)
      ApplicantDeliveryJob.perform_later(c100_application) if receipt?
    end

    private

    def receipt?
      c100_application.receipt_email?
    end

    # Thread-safe mechanism.
    # Do not use `find_or_create` as there are race-conditions
    #
    def ready_to_process
      EmailSubmission.create(c100_application: c100_application)
    rescue ActiveRecord::RecordNotUnique
      # do nothing and return `nil` if record already exists
      nil
    end
  end
end
