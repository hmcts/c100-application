module Summary
  module HtmlSections
    class ApplicantAbuseDetails < BaseAbuseDetails
      def name
        :applicant_abuse_details
      end

      def subject
        AbuseSubject::APPLICANT
      end
    end
  end
end
