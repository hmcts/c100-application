class EmailSubmission < ApplicationRecord
  belongs_to :c100_application

  # The following are utility methods used to manually trigger the emails.
  # Do not rely on these methods other than to force manual submissions in
  # case of bounces or errors.
  #
  # These methods are also used in the back-office. If possible, always use
  # the back-office to performs these actions.
  #
  # :nocov:
  def resend_court_email!
    CourtDeliveryJob.perform_later(c100_application)
  end

  def resend_user_email!
    ApplicantDeliveryJob.perform_later(c100_application)
  end

  def resend!(type:)
    if type == 'user'
      resend_user_email!
    elsif type == 'court'
      resend_court_email!
    else
      raise 'Unknown email type'
    end
  end
  # :nocov:
end
