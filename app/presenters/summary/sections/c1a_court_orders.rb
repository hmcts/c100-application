module Summary
  module Sections
    class C1aCourtOrders < BaseSectionPresenter
      def name
        :c1a_court_orders
      end

      def answers
        return [
          Separator.not_applicable
        ] if court_order.nil?

        orders_made.map do |name|
          [
            Answer.new(:c1a_order_name, name),
            FreeTextAnswer.new(:c1a_order_case_number, answer_for(name, :case_number)),
            DateAnswer.new(:c1a_order_issue_date, answer_for(name, :issue_date)),
            FreeTextAnswer.new(:c1a_order_length, answer_for(name, :length)),
            Answer.new(:c1a_order_is_current, answer_for(name, :is_current)),
            FreeTextAnswer.new(:c1a_order_court_name, answer_for(name, :court_name)),
            Partial.row_blank_space,
          ]
        end.flatten.select(&:show?)
      end

      private

      def court_order
        @_court_order ||= c100.court_order
      end

      def answer_for(name, field)
        court_order[[name, field].join('_')]
      end

      def orders_made
        CourtOrderType.string_values.select do |name|
          court_order[name].eql?(GenericYesNo::YES.to_s)
        end
      end
    end
  end
end
