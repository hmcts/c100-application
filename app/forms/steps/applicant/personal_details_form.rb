module Steps
  module Applicant
    class PersonalDetailsForm < BaseForm
      attribute :has_previous_name, YesNo
      attribute :previous_name, StrippedString
      attribute :gender, GenderAttribute
      attribute :dob, MultiParamDate
      attribute :birthplace, StrippedString

      validates_inclusion_of :has_previous_name, in: GenericYesNo.values
      validates_presence_of  :previous_name, if: -> { has_previous_name&.yes? }

      validates_inclusion_of :gender, in: Gender.values

      validates_presence_of :dob, :birthplace

      validates :dob, sensible_date: true

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)
        applicant.update(
          attributes_map
        )
      end
    end
  end
end
