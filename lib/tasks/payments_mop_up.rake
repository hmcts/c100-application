# This task runs frequently and calls the GOV.UK Pay API to determine the status
# of any pending payments.
#
# Refer to `app/jobs/payments_mop_up_job.rb` for more details.
#
task payments_mop_up: [:stdout_environment] do
  Rails.logger.info "Starting payments mop-up for intents older than #{mop_up_minutes_ago.iso8601}"

  PaymentsMopUpJob.run(mop_up_minutes_ago)

  Rails.logger.info "Finished payments mop-up for intents older than #{mop_up_minutes_ago.iso8601}"
end

private

def mop_up_minutes_ago
  @_mop_up_minutes_ago ||= ENV.fetch('GOVUK_PAY_MOP_UP_MINUTES_AGO', 30).to_i.minutes.ago
end
