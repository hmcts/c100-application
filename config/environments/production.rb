Rails.application.configure do
  config.lograge.logger = ActiveSupport::Logger.new(STDOUT)
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new
  config.log_level = :info
  config.action_view.logger = nil

  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      host: event.payload[:host],
      params: event.payload[:params].except(*exceptions),
      referrer: event.payload[:referrer],
      session_id: event.payload[:session_id],
      tags: %w{c100-application},
      user_agent: event.payload[:user_agent]
    }
  end

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    address: ENV['SMTP_HOST'],
    domain:  ENV['SMTP_DOMAIN'],
    port: ENV['SMTP_PORT'],
    authentication: 'login',
    enable_starttls_auto: true
  }

  # https://github.com/ruby-i18n/i18n/releases/tag/v1.1.0
  config.i18n.fallbacks = [I18n.default_locale]

  config.active_support.deprecation = :notify

  config.active_record.dump_schema_after_migration = false

  # NB: Because of the way the form builder works, and hence the
  # gov.uk elements formbuilder, exceptions will not be raised for
  # missing translations of model attribute names. The form will
  # get the constantized attribute name itself, in form labels.
  config.action_view.raise_on_missing_translations = false

  # Enforce SSl-only
  config.force_ssl = true

  # Prevent host header poisoning by enforcing absolute redirects
  if ENV['EXTERNAL_URL'].present?
    uri = URI.parse(ENV['EXTERNAL_URL'])
    config.action_controller.default_url_options = {
      host: uri.host, protocol: uri.scheme, port: uri.port
    }
  end
end
