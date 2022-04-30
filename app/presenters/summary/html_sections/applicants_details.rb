module Summary
  module HtmlSections
    class ApplicantsDetails < PeopleDetails
      def name
        :applicants_details
      end

      def record_collection
        c100.applicants
      end

      protected

      def names_path
        edit_steps_applicant_names_path(id: '')
      end

      def personal_details_path(person)
        edit_steps_applicant_personal_details_path(person)
      end

      def contact_details_path(person)
        edit_steps_applicant_contact_details_path(person)
      end

      def address_details_path(person)
        edit_steps_applicant_address_details_path(person)
      end

      def child_relationship_path(person, child)
        "/steps/applicant/relationship/#{person.to_param}/child/#{child.to_param}"
      end
    end
  end
end
