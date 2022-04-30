module Summary
  module HtmlSections
    class CourtOrders < Sections::BaseSectionPresenter
      def name
        :court_orders
      end

      def answers
        [
          Answer.new(:has_court_orders, c100.has_court_orders,
                     change_path: edit_steps_court_orders_has_orders_path),

          AnswersGroup.new(:court_orders_details, orders_questions,
                           change_path: edit_steps_court_orders_details_path),
        ].select(&:show?)
      end

      private

      def court_order
        @_court_order ||= c100.court_order
      end

      def answer_for(name, field)
        court_order[[name, field].join('_')]
      end

      def orders_made
        return [] if court_order.nil?

        CourtOrderType.string_values.select do |name|
          court_order[name].eql?(GenericYesNo::YES.to_s)
        end
      end

      def orders_questions
        orders_made.map do |name|
          [
            Answer.new(:order_name, name),
            FreeTextAnswer.new(:order_case_number, answer_for(name, :case_number)),
            DateAnswer.new(:order_issue_date, answer_for(name, :issue_date)),
            FreeTextAnswer.new(:order_length, answer_for(name, :length)),
            Answer.new(:order_is_current, answer_for(name, :is_current)),
            FreeTextAnswer.new(:order_court_name, answer_for(name, :court_name)),
            Partial.horizontal_rule,
          ]
        end.flatten[0..-2] # Return all elements but the last horizontal rule
      end
    end
  end
end
