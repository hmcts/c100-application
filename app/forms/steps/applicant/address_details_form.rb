module Steps
  module Applicant
    class AddressDetailsForm < AddressBaseForm
      attribute :residence_requirement_met, YesNo
      attribute :residence_history, String
      attribute :residence_keep_private, YesNo

      validates_presence_of :country

      validates_inclusion_of :residence_requirement_met, in: GenericYesNo.values
      validates_inclusion_of :residence_keep_private, in: GenericYesNo.values, if: -> { address_confidential? }
      validates_presence_of :residence_history, if: -> { residence_requirement_met&.no? }

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)
        applicant.update(
          address_values.merge(
            residence_requirement_met: residence_requirement_met,
            residence_history: residence_history,
            residence_keep_private: residence_keep_private
          )
        )
      end

      def address_confidential?
        raise C100ApplicationNotFound unless c100_application
        c100_application.address_confidentiality == 'yes'
      end
    end
  end
end
