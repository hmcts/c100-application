module Summary
  module Sections
    class C8CourtDetails < BaseSectionPresenter
      def name
        :c8_court_details
      end

      def answers
        [
          Partial.new(:admin_court_and_case_number),
          Partial.row_blank_space,
          Answer.new(:c8_children_names, :c8_children_numbers),
          *children_boxes
        ].select(&:show?)
      end

      private

      def children_boxes
        c100.children.map do |child|
          AnswerBox.new(child.full_name)
        end
      end
    end
  end
end
