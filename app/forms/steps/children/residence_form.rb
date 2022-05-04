module Steps
  module Children
    class ResidenceForm < BaseForm
      attribute :person_ids, Array[String]

      validate :at_least_one_person_validation

      # These are all the parties available to choose from
      def people
        [
          c100_application.applicants,
          c100_application.respondents,
          c100_application.other_parties
        ].flatten
      end

      private

      def selected_person_ids
        person_ids & people.map(&:id)
      end

      def at_least_one_person_validation
        errors.add(:person_ids, :blank) unless selected_person_ids.any?
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record.update(
          person_ids: selected_person_ids,
        )
      end
    end
  end
end
