# This interceptor is only used in dev or test environments.
# Refer to `/initializers/court_email_interceptor.rb` for more information.
#
class CourtEmailInterceptor
  # Add here the delivery handlers allowed to bypass the interception.
  DELIVERY_WHITELIST = %w[
    NotifyMailer
    ReportsMailer
  ].freeze

  class << self
    def delivering_email(message)
      return if whitelisted?(message)
      intercept_email!(message)
    end

    private

    def whitelisted?(message)
      DELIVERY_WHITELIST.include?(message.delivery_handler.to_s)
    end

    # As we are sending the emails with Notify, there is nothing we can change
    # other than the recipient (`to`) but that's the important bit.
    #
    def intercept_email!(message)
      Rails.logger.warn "Email intended for #{message.to} intercepted. Sending to #{message.from}"
      message.to = message.from
    end
  end
end
