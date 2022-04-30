module Summary
  module HtmlSections
    class ChildrenDetails < Summary::HtmlSections::BaseChildrenDetails
      def name
        :children_details
      end

      def record_collection
        c100.children
      end

      protected

      def names_path
        edit_steps_children_names_path(id: '')
      end

      def personal_details_path(child)
        edit_steps_children_personal_details_path(child)
      end
    end
  end
end
