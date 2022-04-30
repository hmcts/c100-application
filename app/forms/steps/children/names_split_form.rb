module Steps
  module Children
    class NamesSplitForm < NamesSplitBaseForm
      private

      def record_collection
        @_record_collection ||= c100_application.children
      end
    end
  end
end
