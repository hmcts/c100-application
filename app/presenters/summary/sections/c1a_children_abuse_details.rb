module Summary
  module Sections
    class C1aChildrenAbuseDetails < C1aBaseAbuseDetails
      def name
        :c1a_children_abuse_details
      end

      def show_header?
        false
      end

      # For children, we filter the `other` abuse, because
      # it has its own section later in the PDF.
      def filtered_abuses
        [AbuseType::OTHER]
      end

      def subject
        AbuseSubject::CHILDREN
      end
    end
  end
end
