module Summary
  module Sections
    class ChildrenRelationships < BaseSectionPresenter
      def name
        :children_relationships
      end

      def answers
        [:applicants, :respondents, :other_parties].map do |person_type|
          relationships_of_type(person_type)
        end.sum + [
          Partial.row_blank_space,
        ].select(&:show?)
      end

      private

      def relationships_of_type(person_type)
        c100.send(person_type).map.with_index(1) do |person, index|
          relationship_with(person_type, person, index)
        end
      end

      def relationship_with(person_type, person, index)
        FreeTextAnswer.new(
          "#{person_type}_relationships".to_sym,
          RelationshipsPresenter.new(c100_application).relationship_to_children(person),
          i18n_opts: { index: index }
        )
      end
    end
  end
end
