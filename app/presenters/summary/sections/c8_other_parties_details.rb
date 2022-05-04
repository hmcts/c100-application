module Summary
  module Sections
    class C8OtherPartiesDetails < PeopleDetails
      def name
        :c8_other_parties_details
      end

      def show_header?
        true
      end

      # Always show the relationships in the C8 form, as opposite to the C100
      def bypass_relationships_c8?
        true
      end

      def record_collection
        c100.other_parties
      end
    end
  end
end
