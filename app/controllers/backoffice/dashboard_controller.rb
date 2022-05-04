module Backoffice
  class DashboardController < Backoffice::ApplicationController
    include Auth0Secured

    def index
      @form = Backoffice::LookupForm.new

      @report = completed_report
      @payments_report = payments_report
    end

    def lookup
      @form = Backoffice::LookupForm.new(form_params)
      @report = []

      render :lookup && return if @form.invalid?

      if (@application = CompletedApplicationsAudit.find_by(reference_code: @form.reference_code))
        audit!(
          action: :application_lookup,
          details: { reference_code: @form.reference_code, found: true, completed: true }
        )
      elsif (@application = C100Application.find_by_reference_code(@form.reference_code))
        audit!(
          action: :application_lookup,
          details: { reference_code: @form.reference_code, found: true, completed: false }
        )
      else
        audit!(
          action: :application_lookup,
          details: { reference_code: @form.reference_code, found: false }
        )
      end
    end

    # Will change the payment method to phone, as a fallback, as this is most likely
    # an application having issues with online payments, or an user not fully completing
    # the payment journey and letting the payment expire (time out).
    # This is mainly an issue with non-saved applications as the user can't return to it.
    # Mark as completed and trigger the submission emails.
    #
    def complete_application
      c100_application = C100Application.not_completed.find(params[:dashboard_id])

      c100_application.update_column(
        :payment_type, PaymentType::SELF_PAYMENT_CARD.value
      )

      c100_application.mark_as_completed!
      C100App::OnlineSubmissionQueue.new(c100_application).process

      audit!(
        action: :application_completed,
        details: { reference_code: c100_application.reference_code, payment_type: c100_application.payment_type }
      )

      redirect_to backoffice_dashboard_index_path, flash: {
        alert: "Application #{c100_application.reference_code} has been completed and emails will be sent shortly."
      }
    end

    private

    def form_params
      params.require(:backoffice_lookup_form).permit(:reference_code)
    end

    def default_limit
      50
    end

    def completed_report
      CompletedApplicationsAudit.unscoped.order(completed_at: :desc).limit(default_limit)
    end

    def payments_report
      PaymentIntent.order(updated_at: :desc).limit(default_limit)
    end
  end
end
