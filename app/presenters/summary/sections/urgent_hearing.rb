module Summary
  module Sections
    class UrgentHearing < BaseSectionPresenter
      def name
        :urgent_hearing
      end

      def answers
        [
          Answer.new(:urgent_hearing, c100.urgent_hearing, default: GenericYesNo::NO),
          FreeTextAnswer.new(:urgent_hearing_details, c100.urgent_hearing_details),
          FreeTextAnswer.new(:urgent_hearing_when, c100.urgent_hearing_when),
          Answer.new(:urgent_hearing_short_notice, c100.urgent_hearing_short_notice),
          FreeTextAnswer.new(:urgent_hearing_short_notice_details, c100.urgent_hearing_short_notice_details),
        ].select(&:show?)
      end
    end
  end
end
