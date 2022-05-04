module Steps
  module Applicant
    class NamesSplitForm < NamesSplitBaseForm
      private

      def record_collection
        @_record_collection ||= c100_application.applicants
      end
    end
  end
end
