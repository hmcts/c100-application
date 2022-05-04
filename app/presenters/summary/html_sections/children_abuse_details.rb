module Summary
  module HtmlSections
    class ChildrenAbuseDetails < BaseAbuseDetails
      def name
        :children_abuse_details
      end

      def subject
        AbuseSubject::CHILDREN
      end
    end
  end
end
