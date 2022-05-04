module Summary
  module Sections
    class OtherPartiesDetails < PeopleDetails
      def name
        :other_parties_details
      end

      def record_collection
        @_record_collection ||= c100.other_parties
      end

      def answers
        return [
          Separator.not_applicable
        ] if record_collection.empty?

        return [
          Separator.new(:c8_attached)
        ] if c100.confidentiality_enabled?

        super
      end
    end
  end
end
