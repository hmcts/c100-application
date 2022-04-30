module Summary
  module Sections
    class WithoutNoticeHearing < BaseSectionPresenter
      def name
        :without_notice_hearing
      end

      def answers
        [
          Answer.new(:without_notice_hearing_details,            c100.without_notice, default: GenericYesNo::NO),
          FreeTextAnswer.new(:without_notice_details,            c100.without_notice_details),
          Answer.new(:without_notice_impossible,                 c100.without_notice_impossible),
          FreeTextAnswer.new(:without_notice_impossible_details, c100.without_notice_impossible_details),
          Answer.new(:without_notice_frustrate,                  c100.without_notice_frustrate),
          FreeTextAnswer.new(:without_notice_frustrate_details,  c100.without_notice_frustrate_details),
        ].select(&:show?)
      end
    end
  end
end
