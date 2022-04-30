module Steps
  module Application
    class PaymentForm < BaseForm
      attribute :payment_type, String
      attribute :hwf_reference_number, StrippedString
      attribute :solicitor_account_number, StrippedString

      validates_inclusion_of :payment_type, in: :choices, if: :c100_application

      validates_presence_of :hwf_reference_number, if: :help_with_fees_payment?
      validates_presence_of :solicitor_account_number, if: :solicitor_payment?

      validates :hwf_reference_number, allow_blank: true, help_with_fees_reference: true, if: :help_with_fees_payment?

      def choices
        @_choices ||= ValidPaymentsArray.new(c100_application)
      end

      private

      def help_with_fees_payment?
        payment_type.eql?(PaymentType::HELP_WITH_FEES.to_s)
      end

      def solicitor_payment?
        payment_type.eql?(PaymentType::SOLICITOR.to_s)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          payment_type: payment_type,
          hwf_reference_number: (hwf_reference_number if help_with_fees_payment?),
          solicitor_account_number: (solicitor_account_number if solicitor_payment?),
        )
      end
    end
  end
end
