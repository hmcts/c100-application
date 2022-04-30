module Steps
  module Respondent
    class NamesSplitForm < NamesSplitBaseForm
      private

      def record_collection
        @_record_collection ||= c100_application.respondents
      end
    end
  end
end
