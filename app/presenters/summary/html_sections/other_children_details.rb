module Summary
  module HtmlSections
    class OtherChildrenDetails < Summary::HtmlSections::BaseChildrenDetails
      def name
        :other_children_details
      end

      def record_collection
        c100.other_children
      end

      protected

      def names_path
        edit_steps_other_children_names_path(id: '')
      end

      def personal_details_path(child)
        edit_steps_other_children_personal_details_path(child)
      end
    end
  end
end
