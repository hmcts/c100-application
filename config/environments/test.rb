Rails.application.config.before_configuration do
  Raven.configuration.silence_ready = true
end

class Pa11yciHeader
  DEFAULT_NAME = 'PA11YCI'.freeze

  def initialize(app, opts = {}, &blk)
    @app = app
    @blk = blk
    @header_name = ['HTTP_', (opts[:header_name] || DEFAULT_NAME)].join
  end

  attr_reader :app, :header_name, :blk

  def call(env)
    req = ActionDispatch::Request.new(env)
    blk.call(req, req.get_header(header_name)) if req.has_header?(header_name)
    app.call(req.env)
  end
end

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = true
  config.action_view.cache_template_loading = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  config.active_job.queue_adapter = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # So we can always expect the same value in tests
  routes.default_url_options = { host: 'https://c100.justice.uk' }
  config.action_mailer.default_url_options = { host: 'https://c100.justice.uk' }

  # Raises error for missing translations.
  config.action_view.raise_on_missing_translations = true
  config.x.analytics_tracking_id = 'faketrackingid'

  config.middleware.use(Pa11yciHeader) do |request, postcode|
    request.session[:c100_application_id] = C100Application.create(
      children_postcode: postcode,
      status: 1,
    ).id
  end
end
