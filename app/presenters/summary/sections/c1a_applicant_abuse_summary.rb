module Summary
  module Sections
    class C1aApplicantAbuseSummary < C1aBaseAbuseSummary
      def name
        :c1a_applicant_abuse_summary
      end

      def subject
        AbuseSubject::APPLICANT
      end
    end
  end
end
