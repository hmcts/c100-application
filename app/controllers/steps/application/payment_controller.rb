module Steps
  module Application
    class PaymentController < Steps::ApplicationStepController
      def edit
        @form_object = PaymentForm.build(current_c100_application)
      end

      def update
        update_and_advance(PaymentForm, as: :payment)
      end
    end
  end
end
