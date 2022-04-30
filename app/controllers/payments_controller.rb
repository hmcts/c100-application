class PaymentsController < ApplicationController
  def validate
    payment_intent.revoke_nonce!

    redirect_to C100App::PaymentsFlowControl.new(
      current_c100_application
    ).next_url
  end

  private

  # Raises an `ActiveRecord::RecordNotFound` error when there is no intent,
  # and is captured, reported to Sentry and handled in the superclass.
  #
  def payment_intent
    @_payment_intent ||= PaymentIntent.find_by!(
      id: params.require(:id), nonce: params.require(:nonce), c100_application: current_c100_application
    )
  end
end
