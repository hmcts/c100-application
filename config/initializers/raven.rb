# Will use SENTRY_DSN environment variable if set
#
Raven.configure do |config|
  config.environments = %w( production )
  config.silence_ready = true

  config.async = ->(event) { SentryJob.perform_later(event) }

  # Convert to regex, otherwise Sentry will threat them as words
  # https://github.com/getsentry/raven-ruby/blob/master/lib/raven/processor/sanitizedata.rb
  config.sanitize_fields = Rails.application.config.filter_parameters.map { |w| "#{w}+" }
end
