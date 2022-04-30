module Summary
  module Sections
    class C1aChildrenDetails < BaseChildrenDetails
      def name
        :c1a_children_details
      end

      def answers
        c100.children.map.with_index(1) do |child, index|
          [
            Separator.new(:child_index_title, index: index),
            personal_details(child),
            MultiAnswer.new(:child_applicants_relationship, relation_to_child(child, c100.applicants)),
            Partial.row_blank_space,
          ]
        end.flatten.select(&:show?)
      end
    end
  end
end
