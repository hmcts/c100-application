module Summary
  module Sections
    class OtherChildrenDetails < BaseChildrenDetails
      def name
        :other_children_details
      end

      def answers
        return [Separator.not_applicable] if children.empty?

        [
          children_details
        ].flatten.select(&:show?)
      end

      private

      def children_details
        children.map.with_index(1) do |child, index|
          [
            Separator.new(:child_index_title, index: index),
            personal_details(child),
            relationships(child),
          ]
        end
      end

      def children
        @_children ||= c100.other_children
      end
    end
  end
end
