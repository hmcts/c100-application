class BackofficeAuditRecord < ApplicationRecord
  # Do not remove or rename any of these to ensure the audit trail
  # is maintained. Only add new actions when needed.
  #
  enum action: {
    login: 'login',
    logout: 'logout',
    forbidden: 'forbidden',
    application_lookup: 'application_lookup',
    application_completed: 'application_completed',
    email_lookup: 'email_lookup',
    resend_email: 'resend_email',
  }

  def self.log!(author:, action:, details: {})
    create(
      author: author,
      action: action,
      details: details
    )
  end

  # :nocov:
  def self.purge!(date)
    where('created_at <= :date', date: date).destroy_all
  end
  # :nocov:
end
