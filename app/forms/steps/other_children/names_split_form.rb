module Steps
  module OtherChildren
    class NamesSplitForm < NamesSplitBaseForm
      private

      def record_collection
        @_record_collection ||= c100_application.other_children
      end
    end
  end
end
