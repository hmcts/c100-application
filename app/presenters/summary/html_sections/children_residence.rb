module Summary
  module HtmlSections
    class ChildrenResidence < Sections::BaseSectionPresenter
      def name
        :children_residence
      end

      def answers
        c100.children.map do |child|
          FreeTextAnswer.new(
            :child_residence,
            residence_for(child),
            change_path: edit_steps_children_residence_path(child),
            i18n_opts: {child_name: child.full_name}
          )
        end.select(&:show?)
      end

      private

      def residence_for(child)
        Person.where(
          id: child.child_residence&.person_ids
        ).map(&:full_name).to_sentence
      end
    end
  end
end
