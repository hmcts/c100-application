module Steps
  module Petition
    class OrdersController < Steps::PetitionStepController
      def edit
        @form_object = OrdersForm.build(current_c100_application)
      end

      def update
        update_and_advance(OrdersForm, as: :orders)
      end
    end
  end
end
