module Summary
  module Sections
    class MiamRequirement < BaseSectionPresenter
      def name
        :miam_requirement
      end

      def show_header?
        false
      end

      def answers
        [
          Partial.new(:miam_information),

          Answer.new(:miam_consent_order,        c100.consent_order),
          Answer.new(:miam_child_protection,     c100.child_protection_cases),

          Answer.new(:miam_exemption_claim,      c100.miam_exemption_claim,    default: default_value),
          Answer.new(:miam_mediator_exemption,   c100.miam_mediator_exemption, default: default_value),
          Answer.new(:miam_certificate_received, c100.miam_certification,      default: default_value),
          Answer.new(:miam_attended,             c100.miam_attended,           default: default_value),
        ].select(&:show?)
      end

      private

      # For consent orders or child protection cases we don't ask the applicant
      # the MIAM certification questions, as these do not apply.
      def default_value
        return :not_applicable if c100.consent_order? || c100.child_protection_cases?

        GenericYesNo::NO
      end
    end
  end
end
