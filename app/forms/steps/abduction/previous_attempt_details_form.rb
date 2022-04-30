module Steps
  module Abduction
    class PreviousAttemptDetailsForm < BaseForm
      include HasOneAssociationForm

      has_one_association :abduction_detail

      attribute :previous_attempt_details, String
      attribute :previous_attempt_agency_involved, YesNo
      attribute :previous_attempt_agency_details, String

      validates_presence_of  :previous_attempt_details
      validates_presence_of  :previous_attempt_agency_details, if: -> { previous_attempt_agency_involved&.yes? }

      validates_inclusion_of :previous_attempt_agency_involved, in: GenericYesNo.values

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          attributes_map.merge(
            previous_attempt_agency_details: (previous_attempt_agency_details if previous_attempt_agency_involved.yes?)
          )
        )
      end
    end
  end
end
