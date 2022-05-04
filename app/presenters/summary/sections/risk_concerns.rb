module Summary
  module Sections
    class RiskConcerns < BaseSectionPresenter
      def name
        :risk_concerns
      end

      def to_partial_path
        'steps/completion/shared/risk_concerns'
      end

      def answers
        [
          Answer.new(:domestic_abuse,     any_domestic_abuse,     default: default_value),
          Answer.new(:children_abduction, c100.risk_of_abduction, default: default_value),
          Answer.new(:children_abuse,     any_children_abuse,     default: default_value),
          Answer.new(:substance_abuse,    c100.substance_abuse,   default: default_value),
          Answer.new(:other_concerns,     c100.other_abuse,       default: default_value),
        ]
      end

      def c1a_triggered?
        c100.has_safety_concerns?
      end

      def confidentiality_enabled?
        c100.confidentiality_enabled?
      end

      private

      def default_value
        GenericYesNo::NO
      end

      def any_domestic_abuse
        [
          c100.domestic_abuse,
          *abuse_answers_for(AbuseSubject::APPLICANT),
        ].detect { |answer| answer.eql?(GenericYesNo::YES.to_s) }
      end

      def any_children_abuse
        [
          c100.children_abuse,
          *abuse_answers_for(AbuseSubject::CHILDREN),
        ].detect { |answer| answer.eql?(GenericYesNo::YES.to_s) }
      end

      def abuse_answers_for(subject)
        c100.abuse_concerns.where(subject: subject).pluck(:answer)
      end
    end
  end
end
