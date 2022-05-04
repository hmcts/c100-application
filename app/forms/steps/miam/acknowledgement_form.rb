module Steps
  module Miam
    class AcknowledgementForm < BaseForm
      attribute :miam_acknowledgement, Boolean
      attribute :mediation_voucher_scheme, YesNo

      validates_presence_of :miam_acknowledgement
      validates_inclusion_of :mediation_voucher_scheme, in: GenericYesNo.values

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          miam_acknowledgement: miam_acknowledgement,
          mediation_voucher_scheme:  mediation_voucher_scheme
        )
      end
    end
  end
end
