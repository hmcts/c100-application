module Steps
  module Solicitor
    class PersonalDetailsForm < BaseForm
      include HasOneAssociationForm

      has_one_association :solicitor

      attribute :full_name, StrippedString
      attribute :firm_name, StrippedString
      attribute :reference, StrippedString

      validates_presence_of :full_name, :firm_name

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
