module Summary
  module Sections
    class C1aProtectionOrders < BaseSectionPresenter
      def name
        :c1a_protection_orders
      end

      def show_header?
        false
      end

      def answers
        [
          FreeTextAnswer.new(:c1a_protection_orders, c100.protection_orders_details, show: true),
          Answer.new(:c1a_contact_type, c100.concerns_contact_type),
          Answer.new(:c1a_contact_other, c100.concerns_contact_other),
        ].select(&:show?)
      end
    end
  end
end
