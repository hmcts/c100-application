module Summary
  module Sections
    class C100CourtDetails < BaseSectionPresenter
      def name
        :c100_court_details
      end

      def answers
        [
          Partial.new(:admin_court_and_case_number),
          Partial.new(:admin_date_issued),
        ]
      end
    end
  end
end
