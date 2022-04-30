module Steps
  module Children
    class OrdersController < Steps::ChildrenStepController
      before_action :set_petition_orders, only: [:edit, :update]

      def edit
        @form_object = OrdersForm.new(
          c100_application: current_c100_application,
          orders: current_record.child_order.try(:orders),
          record: current_record,
        )
      end

      def update
        update_and_advance(
          OrdersForm,
          record: current_record,
          as: :orders
        )
      end

      private

      def set_petition_orders
        @petition = PetitionPresenter.new(current_c100_application)
      end
    end
  end
end
