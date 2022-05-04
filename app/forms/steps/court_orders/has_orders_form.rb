module Steps
  module CourtOrders
    class HasOrdersForm < BaseForm
      include SingleQuestionForm

      # The reset will delete the row from the `court_orders` table
      yes_no_attribute :has_court_orders, reset_when_no: [:court_order]
    end
  end
end
