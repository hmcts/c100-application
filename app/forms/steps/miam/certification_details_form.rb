module Steps
  module Miam
    class CertificationDetailsForm < BaseForm
      attribute :miam_certification_number, StrippedString
      attribute :miam_certification_service_name, StrippedString
      attribute :miam_certification_sole_trader_name, StrippedString

      validates_presence_of :miam_certification_number,
                            :miam_certification_service_name

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          attributes_map
        )
      end
    end
  end
end
