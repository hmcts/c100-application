module Summary
  module Sections
    class C1aCourtDetails < BaseSectionPresenter
      def name
        :c1a_court_details
      end

      def answers
        [
          Partial.new(:admin_court_and_case_number),
          Partial.new(:admin_date_issued),
          Partial.new(:admin_orders_applied_for),
        ]
      end
    end
  end
end
