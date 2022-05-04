module Summary
  module Sections
    class HelpWithFees < BaseSectionPresenter
      def name
        :help_with_fees
      end

      def answers
        [
          FreeTextAnswer.new(:hwf_reference_number, c100.hwf_reference_number, show: true),
        ].select(&:show?)
      end
    end
  end
end
