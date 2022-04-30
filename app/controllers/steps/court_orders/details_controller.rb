module Steps
  module CourtOrders
    class DetailsController < Steps::CourtOrdersStepController
      def edit
        @form_object = DetailsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(DetailsForm, as: :orders_details)
      end
    end
  end
end
