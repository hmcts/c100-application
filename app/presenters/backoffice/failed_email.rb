module Backoffice
  class FailedEmail < SimpleDelegator
    COURT_TYPE = 'court'.freeze

    def record
      self[:record]
    end

    def type
      self[:reference].split(';').first
    end

    def reference
      self[:reference].split(';').last
    end

    def error
      self[:error]
    end

    def address
      court_email? ? record.to_address : record.email_copy_to
    end

    def sent_at
      date = court_email? ? record.sent_at : record.user_copy_sent_at
      format_date(date)
    end

    private

    def court_email?
      type == COURT_TYPE
    end

    def format_date(date)
      date ? I18n.l(date, format: :short) : 'never'
    end
  end
end
