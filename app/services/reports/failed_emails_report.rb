# frozen_string_literal: true

module Reports
  # :nocov:
  class FailedEmailsReport
    require 'csv'

    USER_EMAIL_TYPE  = 'user'
    COURT_EMAIL_TYPE = 'court'
    SUCCESSFUL_STATUS_CALLBACK = 'delivered'

    class_attribute :failures,
                    :report_type

    class << self
      # This class method is used in the back-office
      def list
        self.report_type = :backoffice
        self.failures = []

        # We skip emails created in the last few minutes to give a bit of time
        # for these recent callbacks to come back.
        EmailSubmission.where(
          created_at: 1.week.ago.beginning_of_day...10.minutes.ago
        ).joins(:c100_application).find_each(batch_size: 25) do |record|
          reference_code = record.c100_application.reference_code

          find_failures(record, reference_code, COURT_EMAIL_TYPE)

          # Only if the applicant chose to receive a confirmation, otherwise
          # these emails are not sent and there is no need to do any check.
          find_failures(record, reference_code, USER_EMAIL_TYPE) if record.c100_application.receipt_email?
        end

        failures
      end

      # This class method is used in `lib/tasks/daily_tasks.rake`
      def run
        self.report_type = :daily_tasks
        self.failures = []

        EmailSubmission.where(
          created_at: Date.yesterday...Date.current
        ).joins(:c100_application).find_each(batch_size: 25) do |record|
          reference_code = record.c100_application.reference_code

          find_failures(record, reference_code, COURT_EMAIL_TYPE)

          # Only if the applicant chose to receive a confirmation, otherwise
          # these emails are not sent and there is no need to do any check.
          find_failures(record, reference_code, USER_EMAIL_TYPE) if record.c100_application.receipt_email?
        end

        send_email_report if failures.any?
      end

      def find_failures(record, reference_code, email_type)
        reference = [email_type, reference_code].join(';').freeze

        if record.sent_at.nil?
          failures << report_line(record, reference, 'error')
          return
        end

        # Ignore following failures when sending the report, as these are very
        # frequently user typos, and nothing we can fix on our side.
        return if report_type == :daily_tasks && email_type == USER_EMAIL_TYPE

        status = EmailSubmissionsAudit.unscoped.order(completed_at: :desc).find_by(
          reference: reference,
        )&.status || 'callback-missing'

        return if status == SUCCESSFUL_STATUS_CALLBACK

        failures << report_line(record, reference, status)
      end

      def report_line(record, reference, error_msg)
        if report_type == :backoffice
          Backoffice::FailedEmail.new(
            record: record,
            reference: reference,
            error: error_msg,
          )
        else
          [
            record.created_at,
            reference,
            error_msg,
          ]
        end
      end

      def send_email_report
        # Unset the env variable to stop the emails (for example
        # on staging we don't want these emails, only on production)
        return unless ENV.key?('SEND_FAILED_EMAILS_REPORT')

        recipients = BackofficeUser.active.pluck(:email)
        report = failures.map(&:to_csv).join

        Rails.logger.info "Sending failed emails report to #{recipients.size} recipients..."

        recipients.each do |recipient|
          ReportsMailer.failed_emails_report(report, to_address: recipient).deliver_later
        end
      end
    end
  end
  # :nocov:
end
