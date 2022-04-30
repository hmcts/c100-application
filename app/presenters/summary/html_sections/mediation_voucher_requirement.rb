module Summary
  module HtmlSections
    class MediationVoucherRequirement < Sections::BaseSectionPresenter
      def name
        :mediation_voucher
      end

      def answers
        [
          Answer.new(:mediation_voucher_scheme, c100.mediation_voucher_scheme,
                     change_path: edit_steps_miam_acknowledgement_path)
        ].select(&:show?)
      end
    end
  end
end
