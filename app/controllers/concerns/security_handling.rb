module SecurityHandling
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :exception, prepend: true

    before_action :drop_dangerous_headers!,
                  :check_http_credentials
  end

  private

  def drop_dangerous_headers!
    request.env.except!('HTTP_X_FORWARDED_HOST') # just drop the variable
  end

  def check_http_credentials
    return unless ENV.key?('HTTP_AUTH_ENABLED')

    # :nocov:
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch('HTTP_AUTH_USER') && password == ENV.fetch('HTTP_AUTH_PASSWORD')
    end
    # :nocov:
  end
end
