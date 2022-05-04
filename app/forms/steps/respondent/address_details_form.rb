module Steps
  module Respondent
    class AddressDetailsForm < AddressBaseForm
      attribute :residence_requirement_met, YesNoUnknown
      attribute :residence_history, String
      attribute :residence_history_no, String
      attribute :residence_history_unknown, String

      validates_inclusion_of :residence_requirement_met, in: GenericYesNoUnknown.values

      def residence_history_no
        super || (residence_history if residence_requirement_met&.no?)
      end

      def residence_history_unknown
        super || (residence_history if residence_requirement_met&.unknown?)
      end

      def residence_history_value
        return residence_history_no if residence_requirement_met&.no?
        return residence_history_unknown if residence_requirement_met&.unknown?
      end

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        respondent = c100_application.respondents.find_or_initialize_by(id: record_id)
        respondent.update(
          address_values.merge(
            residence_requirement_met: residence_requirement_met,
            residence_history: residence_history_value,
          )
        )
      end
    end
  end
end
