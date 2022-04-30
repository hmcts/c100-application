module Summary
  module HtmlSections
    class LitigationCapacity < Sections::BaseSectionPresenter
      def name
        :litigation_capacity
      end

      def answers
        [
          Answer.new(
            :reduced_litigation_capacity,
            c100.reduced_litigation_capacity,
            change_path: edit_steps_application_litigation_capacity_path
          ),
          AnswersGroup.new(
            :litigation_capacity,
            [
              FreeTextAnswer.new(:participation_capacity_details,
                                 c100.participation_capacity_details),
              FreeTextAnswer.new(:participation_other_factors_details,
                                 c100.participation_other_factors_details),
              FreeTextAnswer.new(:participation_referral_or_assessment_details,
                                 c100.participation_referral_or_assessment_details),
            ],
            change_path: edit_steps_application_litigation_capacity_details_path
          )
        ].select(&:show?)
      end
    end
  end
end
