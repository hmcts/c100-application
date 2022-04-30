# There are 2 failure cases which affect the integration with GOV.UK Pay:
#
# - the user abandons their payment journey before completing it
# - the user completes their payment successfully, but their network connection
#   is interrupted before they return to our service
#
# In these failure cases, the user will never visit the `return_url`.
#
# Instead, we must use an automatic mop-up job as a background process which
# checks the outcome of incomplete payment journeys.
#
class PaymentsMopUpJob < ApplicationJob
  queue_as :default

  def self.run(date)
    C100Application.joins(:payment_intent)
      .where("payment_intents.state ->> 'finished' = 'false'")
      .where("payment_intents.created_at <= :date", date: date)
      .each do |c100_application|
        Rails.logger.info "Enqueuing payment status refresh for application #{c100_application.id}"
        perform_later(c100_application)
      end
  end

  def perform(c100_application)
    Rails.logger.info "Retrieving payment status for application #{c100_application.id}"

    return unless C100App::OnlinePayments.retrieve_payment(
      c100_application.payment_intent
    ).success?

    # In case the application was already completed in between job runs
    return if c100_application.completed?

    Rails.logger.info "Marking as completed application #{c100_application.id}"

    c100_application.mark_as_completed!

    C100App::OnlineSubmissionQueue.new(
      c100_application
    ).process
  end
end
