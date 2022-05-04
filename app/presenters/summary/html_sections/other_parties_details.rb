module Summary
  module HtmlSections
    class OtherPartiesDetails < PeopleDetails
      def name
        :other_parties_details
      end

      def record_collection
        c100.other_parties
      end

      def answers
        [
          Answer.new(
            :has_other_parties,
            c100.has_other_parties,
            change_path: edit_steps_respondent_has_other_parties_path
          ),
          super,
        ].flatten.select(&:show?)
      end

      protected

      def names_path
        edit_steps_other_party_names_path(id: '')
      end

      def personal_details_path(person)
        edit_steps_other_party_personal_details_path(person)
      end

      # Other parties do not have a contact details step
      def contact_details_path(_person)
        nil
      end

      def address_details_path(person)
        edit_steps_other_party_address_details_path(person)
      end

      def child_relationship_path(person, child)
        "/steps/other_party/relationship/#{person.to_param}/child/#{child.to_param}"
      end
    end
  end
end
