module Summary
  module Sections
    class LitigationCapacity < BaseSectionPresenter
      def name
        :litigation_capacity
      end

      def show_header?
        false
      end

      def answers
        [
          Answer.new(:reduced_litigation_capacity, c100.reduced_litigation_capacity),
          FreeTextAnswer.new(:participation_capacity_details, c100.participation_capacity_details),
          FreeTextAnswer.new(:participation_other_factors_details, c100.participation_other_factors_details),
          FreeTextAnswer.new(:participation_referral_or_assessment_details, c100.participation_referral_or_assessment_details),
        ].select(&:show?)
      end
    end
  end
end
