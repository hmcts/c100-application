module Steps
  module CourtOrders
    class HasOrdersController < Steps::CourtOrdersStepController
      def edit
        @form_object = HasOrdersForm.new(
          c100_application: current_c100_application,
          has_court_orders: current_c100_application.has_court_orders
        )
      end

      def update
        update_and_advance(HasOrdersForm, as: :has_court_orders)
      end
    end
  end
end
