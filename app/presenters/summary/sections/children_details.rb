module Summary
  module Sections
    class ChildrenDetails < BaseChildrenDetails
      def name
        :children_details
      end

      def answers
        [
          children_details,
          Answer.new(:children_known_to_authorities, c100.children_known_to_authorities),
          FreeTextAnswer.new(:children_known_to_authorities_details, c100.children_known_to_authorities_details),
          Answer.new(:children_protection_plan, c100.children_protection_plan),
        ].flatten.select(&:show?)
      end

      private

      def children_details
        children.map.with_index(1) do |child, index|
          [
            Separator.new(:child_index_title, index: index),
            personal_details(child),
            relationships(child),
            MultiAnswer.new(:child_orders, order_types(child)),
            # SGO only shows if a value is present
            Answer.new(:special_guardianship_order, child.special_guardianship_order),
            Partial.row_blank_space,
          ]
        end
      end

      def order_types(child)
        child.child_order&.orders.to_a.map do |o|
          PetitionOrder.type_for(o)
        end.uniq
      end

      def children
        @_children ||= c100.children
      end
    end
  end
end
