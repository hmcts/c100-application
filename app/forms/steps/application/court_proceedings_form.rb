module Steps
  module Application
    class CourtProceedingsForm < BaseForm
      include HasOneAssociationForm

      has_one_association :court_proceeding

      attribute :children_names, String
      attribute :court_name, StrippedString
      attribute :case_number, StrippedString
      attribute :proceedings_date, String
      attribute :cafcass_details, String
      attribute :order_types, String
      attribute :previous_details, String

      validates_presence_of :children_names,
                            :court_name,
                            :order_types

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          attributes_map
        )
      end
    end
  end
end
