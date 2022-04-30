module Summary
  module HtmlSections
    class UrgentHearingDetails < Sections::BaseSectionPresenter
      def name
        :urgent_hearing
      end

      def answers
        [
          Answer.new(:urgent_hearing, c100.urgent_hearing,
                     change_path: edit_steps_application_urgent_hearing_path),
          AnswersGroup.new(:urgent_hearing_details, urgent_hearing_details,
                           change_path: edit_steps_application_urgent_hearing_details_path),
        ].select(&:show?)
      end

      private

      def urgent_hearing_details
        [
          FreeTextAnswer.new(:urgent_hearing_details, c100.urgent_hearing_details),
          FreeTextAnswer.new(:urgent_hearing_when, c100.urgent_hearing_when),
          Answer.new(:urgent_hearing_short_notice, c100.urgent_hearing_short_notice),
          FreeTextAnswer.new(:urgent_hearing_short_notice_details, c100.urgent_hearing_short_notice_details),
        ]
      end
    end
  end
end
