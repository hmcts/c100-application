module Steps
  module Application
    class UrgentHearingDetailsForm < BaseForm
      attribute :urgent_hearing_details, String
      attribute :urgent_hearing_when, String
      attribute :urgent_hearing_short_notice, YesNo
      attribute :urgent_hearing_short_notice_details, String

      validates_presence_of :urgent_hearing_details,
                            :urgent_hearing_when

      validates_inclusion_of :urgent_hearing_short_notice, in: GenericYesNo.values

      validates_presence_of :urgent_hearing_short_notice_details, if: -> { urgent_hearing_short_notice&.yes? }

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
