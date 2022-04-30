module Summary
  module Sections
    class ChildrenResidence < BaseSectionPresenter
      def name
        :children_residence
      end

      def show_header?
        false
      end

      def answers
        [
          MultiAnswer.new(:children_residence, children_residence),
        ].select(&:show?)
      end

      private

      # This will return an array of type of people, for example it may be
      # ["OtherParty", "OtherParty", "Applicant", "Respondent", "Applicant"]
      # We remove duplicates, and sort alphabetically.
      def children_residence
        host_people.pluck(:type).uniq.sort
      end

      def host_people
        Person.where(id: host_person_ids)
      end

      def host_person_ids
        ChildResidence.where(child: c100.children).pluck(:person_ids).flatten
      end
    end
  end
end
