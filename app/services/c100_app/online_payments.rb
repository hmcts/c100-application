module C100App
  class OnlinePayments
    # Sent in metadata and used for HMCTS reconciliation.
    APPLICATION_CODE = 'C100'.freeze

    # Failure codes that indicate either the user do not want to proceed,
    # or the payments provider is having technical issues.
    NON_RETRYABLE_CODES = %w[
      P0030
      P0050
    ].freeze

    attr_reader :payment_intent
    delegate :c100_application, to: :payment_intent

    def initialize(payment_intent)
      @payment_intent = payment_intent
    end
    private_class_method :new

    class << self
      def create_payment(payment_intent)
        new(payment_intent).create_payment
      end

      def retrieve_payment(payment_intent)
        new(payment_intent).retrieve_payment
      end

      def non_retryable_state?(payment_intent)
        NON_RETRYABLE_CODES.include?(payment_intent.state['code'])
      end
    end

    def create_payment
      response = PaymentsApi::Requests::CreateCardPayment.new(
        **details_payload
      ).call

      update_intent!(response)
      response
    end

    def retrieve_payment
      response = PaymentsApi::Requests::GetCardPayment.new(
        payment_id: payment_intent.payment_id
      ).call

      update_intent!(response)
      response
    end

    private

    def update_intent!(response)
      payment_intent.update(
        payment_id: response.payment_id,
        state: response.state,
      )
    end

    def details_payload
      {
        amount: Rails.configuration.x.court_fee.amount_in_pence,
        description: Rails.configuration.x.court_fee.description,
        reference: c100_application.reference_code,
        email: c100_application.receipt_email,

        # One-time return url
        return_url: payment_intent.return_url,

        # Needed for HMCTS reconciliation
        metadata: metadata
      }
    end

    def metadata
      {
        application: APPLICATION_CODE,
        court_gbs: c100_application.court.gbs,
        court_name: c100_application.court.name,
        court_email: c100_application.court.documents_email,
      }
    end
  end
end
