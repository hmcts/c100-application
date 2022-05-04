module Steps
  module Miam
    class CertificationDateForm < BaseForm
      attribute :miam_certification_date, MultiParamDate

      validates_presence_of :miam_certification_date
      validates :miam_certification_date, sensible_date: true

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          miam_certification_date: miam_certification_date
        )
      end
    end
  end
end
