module Steps
  module Abduction
    class PassportDetailsForm < BaseForm
      include HasOneAssociationForm

      has_one_association :abduction_detail

      attribute :children_multiple_passports, YesNo
      attribute :passport_possession, Array[String]
      attribute :passport_possession_other_details, String

      validates_inclusion_of :children_multiple_passports, in: GenericYesNo.values
      validates_presence_of  :passport_possession_other_details, if: :passport_possession_other?

      private

      def passport_possession_other?
        passport_possession.include?(Relation::OTHER.to_s)
      end

      def selected_options
        passport_possession & Relation.string_values
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          children_multiple_passports: children_multiple_passports,
          passport_possession: selected_options,
          passport_possession_other_details: (passport_possession_other_details if passport_possession_other?),
        )
      end
    end
  end
end
