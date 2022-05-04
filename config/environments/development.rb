Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # save mails to tmp/mails
  config.action_mailer.delivery_method = :file
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  # lets you preview action_mailer mails from the browser at:
  # /rails/mailers/(mailer name)/(method name)
  config.action_mailer.preview_path = "#{Rails.root}/app/mailer_previews"
  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true
  config.assets.quiet = true

  # NB: Because of the way the form builder works, and hence the
  # gov.uk elements formbuilder, exceptions will not be raised for
  # missing translations of model attribute names. The form will
  # get the constantized attribute name itself, in form labels.
  config.action_view.raise_on_missing_translations = true

  routes.default_url_options = { host: 'localhost' }
  config.action_mailer.default_url_options = { host: "localhost" }
  config.default_url_options = { host: "localhost" }
end
