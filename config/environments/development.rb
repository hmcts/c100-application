Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # save mails to tmp/mails
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  # lets you preview action_mailer mails from the browser at:
  # /rails/mailers/(mailer name)/(method name)
  config.action_mailer.preview_path = "#{Rails.root}/app/mailer_previews"
  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true
  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # NB: Because of the way the form builder works, and hence the
  # gov.uk elements formbuilder, exceptions will not be raised for
  # missing translations of model attribute names. The form will
  # get the constantized attribute name itself, in form labels.
  config.action_view.raise_on_missing_translations = true

  # Enable console when running via docker compose
  config.web_console.whitelisted_ips = '172.23.0.0/16'

end

Faker::Config.locale = 'en-GB' # For the development tools
