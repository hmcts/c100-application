module Summary
  module Sections
    class CourtFee < BaseSectionPresenter
      def name
        :court_fee
      end

      def answers
        [
          Answer.new(:payment_type, c100.payment_type),
          FreeTextAnswer.new(:hwf_reference_number, c100.hwf_reference_number),
          FreeTextAnswer.new(:solicitor_account_number, c100.solicitor_account_number),
        ].select(&:show?)
      end
    end
  end
end
