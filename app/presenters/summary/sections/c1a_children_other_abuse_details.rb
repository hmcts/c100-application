module Summary
  module Sections
    class C1aChildrenOtherAbuseDetails < C1aBaseAbuseDetails
      def name
        :c1a_children_other_abuse_details
      end

      def show_header?
        false
      end

      # Filter everything but `other`
      def filtered_abuses
        AbuseType.values - [AbuseType::OTHER]
      end

      def subject
        AbuseSubject::CHILDREN
      end
    end
  end
end
