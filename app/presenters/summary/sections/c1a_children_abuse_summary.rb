module Summary
  module Sections
    class C1aChildrenAbuseSummary < C1aBaseAbuseSummary
      def name
        :c1a_children_abuse_summary
      end

      def subject
        AbuseSubject::CHILDREN
      end
    end
  end
end
