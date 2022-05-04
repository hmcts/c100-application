require 'payments_api'

PaymentsApi.configure do |config|
  config.api_key = ENV.fetch('GOVUK_PAY_API_KEY', nil)
end
