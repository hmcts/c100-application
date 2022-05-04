require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Application
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.action_controller.default_protect_from_forgery = false

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

    config.active_job.queue_adapter = ENV.fetch('QUEUE_ADAPTER', :sidekiq).to_sym

    # We are using our own url-shortener. These short urls redirect to surveymonkey,
    # and tracks visits, so we can see if they are being used.
    config.surveys = {
      success: 'https://c100.service.justice.gov.uk/survey',
      kickout: 'https://c100.service.justice.gov.uk/exit_survey',
    }

    config.gds_service_homepage_url = 'https://www.gov.uk/looking-after-children-divorce/apply-for-court-order'.freeze

    # Load the templates set (refer to `config/govuk_notify_templates.yml` for details)
    config.govuk_notify_templates = config_for(
      :govuk_notify_templates, env: ENV.fetch('GOVUK_NOTIFY_ENV', 'integration')
    ).with_indifferent_access

    # Load the court slugs file to handle centralisation or blocking
    config.court_slugs = YAML.load_file(File.join(Rails.root, 'config', 'court_slugs.yml'))

    config.x.session.expires_in_minutes = ENV.fetch('SESSION_EXPIRES_IN_MINUTES', 60).to_i
    config.x.session.warning_when_remaining = ENV.fetch('SESSION_WARNING_WHEN_REMAINING', 5).to_i

    # Show the `research consent` question (used to gather emails of users for research
    # purposes) to this percentage of applications.
    # If ENV is set, takes precedence. Can be set to any value between 0 (disabled) and 100.
    config.x.opening.research_consent_weight = ENV.fetch('RESEARCH_CONSENT_WEIGHT', 0).to_i

    # As part of the opening postcode step, an empty C100Application record is created.
    # If the postcode is not eligible, these records are left orphans and have no use.
    # We will only leave them for some time. Can be configured here.
    config.x.orphans.expire_in_days = 2

    # We maintain C100 applications for this number of days, regardless of their status,
    # and if it has an owner (it was saved for later), we send up to two email reminders
    # before we delete the application. If you change this number make sure to also update
    # `app/services/c100_app/reminder_rule_set.rb` and the Notify email templates.
    config.x.drafts.expire_in_days = 28

    # When a user is purged, any saved C100 applications belonging to them, are also purged.
    config.x.users.expire_in_days = 30

    # Applicant confirmation email, and court email, are sent via Notify, but Notify has a
    # very limited retention period. We maintain an audit (with no personal details) of the
    # delivery result of these emails for diagnostic and debug purposes.
    config.x.email_submissions_audit.expire_in_days = 90

    # The back office maintains an audit trail of all actions performed (for example, resend
    # an email). It logs who did what and when. We should maintain it for a few weeks/months.
    config.x.backoffice_audit.expire_in_days = 90

    # Court fee configuration.
    # Not using Fee Register for now as we only have 1 fee, but might be used in the future.
    config.x.court_fee.amount_in_pence = 232_00
    config.x.court_fee.description = 'Court fee for a child arrangements application (C100)'
    config.x.analytics_tracking_id = ENV['GA_TRACKING_ID']
    config.x.cookie_expiry = 1.year
  end
end
