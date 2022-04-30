module Summary
  module Sections
    class NatureOfApplication < BaseSectionPresenter
      def name
        :nature_of_application
      end

      def answers
        [
          MultiAnswer.new(:child_arrangements_orders, petition.child_arrangements_orders),
          MultiAnswer.new(:prohibited_steps_orders, petition.prohibited_steps_orders),
          MultiAnswer.new(:specific_issues_orders, petition.specific_issues_orders),
          MultiAnswer.new(:formalise_arrangements, petition.formalise_arrangements),
          FreeTextAnswer.new(:other_issue_details, petition.other_issue_details),
        ].select(&:show?)
      end

      private

      def petition
        @_petition ||= PetitionPresenter.new(c100)
      end
    end
  end
end
