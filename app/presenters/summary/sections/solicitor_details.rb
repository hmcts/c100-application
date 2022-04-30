module Summary
  module Sections
    class SolicitorDetails < BaseSectionPresenter
      def name
        :solicitor_details
      end

      def show_header?
        false
      end

      # rubocop:disable Metrics/AbcSize
      def answers
        return [
          Answer.new(:has_solicitor, GenericYesNo::NO)
        ] if solicitor.nil?

        [
          Answer.new(:has_solicitor, GenericYesNo::YES),
          FreeTextAnswer.new(:solicitor_full_name, solicitor.full_name),
          FreeTextAnswer.new(:solicitor_firm_name, solicitor.firm_name),
          FreeTextAnswer.new(:solicitor_address, solicitor.full_address),
          FreeTextAnswer.new(:solicitor_email, solicitor.email),
          FreeTextAnswer.new(:solicitor_phone_number, solicitor.phone_number),
          FreeTextAnswer.new(:solicitor_fax_number, solicitor.fax_number),
          FreeTextAnswer.new(:solicitor_dx_number, solicitor.dx_number),
          FreeTextAnswer.new(:solicitor_reference, solicitor.reference),
          FreeTextAnswer.new(:solicitor_fee_account, c100.solicitor_account_number, show: true),
        ].select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize

      private

      def solicitor
        @_solicitor ||= c100.solicitor
      end
    end
  end
end
