# The queue adapter is set in `config/application.rb`
# Refer to that file for more details.
#
Sidekiq.configure_server do |config|
  config.default_worker_options = {
    backtrace: 3 # top 3 lines
  }

  config.death_handlers << ->(job, ex) do
    Raven.capture_exception(ex, level: 'error', tags: { job_class: job['class'], job_id: job['jid'] })
  end

  Rails.logger = Sidekiq.logger

  if Rails.env.inquiry.production?
    config.log_formatter = Sidekiq::Logger::Formatters::JSON.new

    # Level is `INFO`. If it is too noisy for prod, uncomment this line:
    # config.logger.level = Logger::WARN
  end
end
