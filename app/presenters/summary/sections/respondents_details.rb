module Summary
  module Sections
    class RespondentsDetails < PeopleDetails
      def name
        :respondents_details
      end

      def record_collection
        c100.respondents
      end
    end
  end
end
