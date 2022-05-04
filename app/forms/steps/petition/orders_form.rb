module Steps
  module Petition
    class OrdersForm < BaseForm
      attribute :orders, Array[String]
      attribute :orders_collection, Array[String]
      attribute :orders_additional_details, String

      validate :at_least_one_order_validation
      validates_presence_of :orders_additional_details, if: :other_issue?

      # Custom setter so we always have both attributes synced, as one attribute is
      # the main categories and the other are subcategories.
      # Needed to make the revealing check boxes work nice with errors, etc.
      #
      def orders_collection=(values)
        super(Array(values) | Array(orders))
      end

      private

      # We filter out `group_xxx` items, as the purpose of these are to present the orders
      # in groups for the user to show/hide them, and are not really an order by itself.
      #
      def valid_options
        selected_options.grep_v(/\Agroup_/)
      end

      def selected_options
        (orders_collection + orders) & PetitionOrder.string_values
      end

      def at_least_one_order_validation
        errors.add(:orders, :blank) unless valid_options.any?
      end

      def other_issue?
        selected_options.include?(PetitionOrder::OTHER_ISSUE.to_s)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          orders: selected_options,
          orders_additional_details: (orders_additional_details if other_issue?),
        )
      end
    end
  end
end
