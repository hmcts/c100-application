module Summary
  module HtmlSections
    class WithoutNoticeDetails < Sections::BaseSectionPresenter
      def name
        :without_notice_hearing
      end

      def answers
        [
          Answer.new(:without_notice_hearing, c100.without_notice,
                     change_path: edit_steps_application_without_notice_path),
          AnswersGroup.new(:without_notice_hearing_details, without_notice_hearing_details,
                           change_path: edit_steps_application_without_notice_details_path),
        ].select(&:show?)
      end

      private

      def without_notice_hearing_details
        [
          FreeTextAnswer.new(:without_notice_details,            c100.without_notice_details),
          Answer.new(:without_notice_impossible,                 c100.without_notice_impossible),
          FreeTextAnswer.new(:without_notice_impossible_details, c100.without_notice_impossible_details),
          Answer.new(:without_notice_frustrate,                  c100.without_notice_frustrate),
          FreeTextAnswer.new(:without_notice_frustrate_details,  c100.without_notice_frustrate_details),
        ]
      end
    end
  end
end
