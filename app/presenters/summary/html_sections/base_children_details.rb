module Summary
  module HtmlSections
    class BaseChildrenDetails < Sections::BaseSectionPresenter
      # :nocov:
      def record_collection
        raise 'must be implemented in subclasses'
      end

      def names_path
        raise 'must be implemented in subclasses'
      end

      def personal_details_path(*)
        raise 'must be implemented in subclasses'
      end
      # :nocov:

      def answers
        record_collection.map.with_index(1) do |child, index|
          [
            Separator.new("#{name}_index_title", index: index),
            FreeTextAnswer.new(:person_full_name, child.full_name, change_path: names_path),
            AnswersGroup.new(
              :person_personal_details,
              personal_details_questions(child),
              change_path: personal_details_path(child)
            ),
            MultiAnswer.new(
              :child_orders,
              order_types(child),
              change_path: edit_steps_children_orders_path(child)
            ),
            # SGO only shows if a value is present
            Answer.new(:special_guardianship_order, child.special_guardianship_order,
                       change_path: edit_steps_children_special_guardianship_order_path(child)),
          ]
        end.flatten.select(&:show?)
      end

      private

      def personal_details_questions(child)
        [
          DateAnswer.new(:person_dob, child.dob || child.dob_estimate),
          Answer.new(:person_sex, child.gender),
        ]
      end

      def order_types(child)
        return [] unless child.respond_to?(:child_order)

        child.child_order&.orders.to_a.map do |order|
          PetitionOrder.type_for(order)
        end.uniq
      end
    end
  end
end
