module Summary
  module HtmlSections
    class ChildrenFurtherInformation < Sections::BaseSectionPresenter
      def name
        :children_further_information
      end

      # rubocop:disable Metrics/MethodLength
      def answers
        [
          Answer.new(
            :children_known_to_authorities,
            c100.children_known_to_authorities,
            change_path: edit_steps_children_additional_details_path
          ),
          FreeTextAnswer.new(
            :children_known_to_authorities_details,
            c100.children_known_to_authorities_details,
            change_path: edit_steps_children_additional_details_path
          ),
          Answer.new(
            :children_protection_plan,
            c100.children_protection_plan,
            change_path: edit_steps_children_additional_details_path
          ),
          Answer.new(
            :has_other_children,
            c100.has_other_children,
            change_path: edit_steps_children_has_other_children_path
          ),
        ].select(&:show?)
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
