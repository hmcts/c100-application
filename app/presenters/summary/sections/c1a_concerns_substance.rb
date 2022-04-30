module Summary
  module Sections
    class C1aConcernsSubstance < BaseSectionPresenter
      def name
        :c1a_concerns_details
      end

      # Always show, even if there are no substance abuse, as this will
      # render the concerns section header
      def show?
        true
      end

      def answers
        return [] unless c100.substance_abuse.eql?(GenericYesNo::YES.to_s)

        [
          Answer.new(:c1a_abuse_type, :substance_abuse),
          FreeTextAnswer.new(:c1a_abuse_details, c100.substance_abuse_details),
          Partial.row_blank_space,
        ]
      end
    end
  end
end
