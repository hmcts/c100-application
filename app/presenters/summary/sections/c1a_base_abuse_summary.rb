module Summary
  module Sections
    class C1aBaseAbuseSummary < BaseSectionPresenter
      def answers
        [
          Answer.new(:c1a_abuse_physical,      answer_for(AbuseType::PHYSICAL)),
          Answer.new(:c1a_abuse_emotional,     answer_for(AbuseType::EMOTIONAL)),
          Answer.new(:c1a_abuse_psychological, answer_for(AbuseType::PSYCHOLOGICAL)),
          Answer.new(:c1a_abuse_sexual,        answer_for(AbuseType::SEXUAL)),
          Answer.new(:c1a_abuse_financial,     answer_for(AbuseType::FINANCIAL)),
        ]
      end

      private

      def answer_for(kind)
        c100.abuse_concerns.find_by(
          subject: subject,
          kind: kind,
        )&.answer || default_value
      end

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
