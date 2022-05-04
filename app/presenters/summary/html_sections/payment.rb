module Summary
  module HtmlSections
    class Payment < Sections::BaseSectionPresenter
      def name
        :payment
      end

      def answers
        [
          AnswersGroup.new(
            :payment_type,
            [
              Answer.new(:payment_type, c100.payment_type),
              FreeTextAnswer.new(:hwf_reference_number, c100.hwf_reference_number),
              FreeTextAnswer.new(:solicitor_account_number, c100.solicitor_account_number),
            ],
            change_path: edit_steps_application_payment_path
          )
        ].select(&:show?)
      end
    end
  end
end
