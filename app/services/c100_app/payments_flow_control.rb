require 'payment_intent'
require 'errors'

module C100App
  class PaymentsFlowControl
    include Rails.application.routes.url_helpers

    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def payment_url
      return confirmation_url unless c100_application.online_payment?

      begin
        payment_intent.with_lock do
          move_status_to :payment_in_progress

          # Ensure we are always working with an up to date record
          payment_intent.reload

          if payment_intent.in_progress?
            OnlinePayments.retrieve_payment(payment_intent).payment_url
          else
            OnlinePayments.create_payment(payment_intent).payment_url
          end
        end
      rescue StandardError => exception
        raise Errors::PaymentUnexpectedError, exception
      end
    end

    # Returning users after paying (or failing/cancelling)
    def next_url
      if OnlinePayments.retrieve_payment(payment_intent).success?
        return confirmation_url
      end

      # Revert to `in_progress` as we are certain at this point payment failed
      move_status_to :in_progress

      payment_error_errors_path
    rescue StandardError => exception
      raise Errors::PaymentUnexpectedError, exception
    end

    def confirmation_url
      move_status_to :completed

      if c100_application.online_submission?
        OnlineSubmissionQueue.new(c100_application).process
        steps_completion_confirmation_path
      else
        steps_completion_what_next_path
      end
    end

    private

    def payment_intent
      @_payment_intent ||= PaymentIntent.create_or_find_by!(
        c100_application_id: c100_application.id
      )
    end

    def move_status_to(status)
      case status
      when :in_progress
        c100_application.in_progress!
      when :payment_in_progress
        c100_application.payment_in_progress!
      when :completed
        c100_application.mark_as_completed!
      end
    end
  end
end
