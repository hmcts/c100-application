module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      case exception
      when Errors::InvalidSession, ActionController::InvalidAuthenticityToken
        redirect_to invalid_session_errors_path
      when Errors::ApplicationNotFound
        redirect_to application_not_found_errors_path
      when Errors::ApplicationScreening
        redirect_to application_screening_errors_path
      when Errors::ApplicationCompleted
        redirect_to application_completed_errors_path
      when Errors::PaymentError
        # Payment errors are reported to Sentry as it is important to know
        Raven.capture_exception(exception, tags: { c100_application_id: session[:c100_application_id] })
        redirect_to payment_error_errors_path
      else
        raise if Rails.application.config.consider_all_requests_local

        Raven.capture_exception(exception)
        redirect_to unhandled_errors_path
      end
    end
  end

  private

  def check_c100_application_presence
    raise Errors::InvalidSession unless current_c100_application
  end

  def check_application_not_completed
    raise Errors::ApplicationCompleted if current_c100_application.completed?
  end

  def check_application_not_screening
    raise Errors::ApplicationScreening if current_c100_application.screening?
  end

  # If the application was left in a `payment_in_progress` status, we need to check
  # if the payment went ahead successfully, or not, for the edge cases where the
  # redirect from payments website failed.
  # This complements the automated mop-up job running periodically.
  #
  # We might not have an application in the session at this point, as some actions
  # or controllers can skip the `check_c100_application_presence` callback.
  #
  def check_application_payment_status
    redirect_to C100App::PaymentsFlowControl.new(
      current_c100_application
    ).next_url if current_c100_application.try(:payment_in_progress?)
  end
end
