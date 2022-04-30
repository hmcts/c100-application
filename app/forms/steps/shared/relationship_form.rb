module Steps
  module Shared
    class RelationshipForm < BaseForm
      attribute :relation, String
      attribute :relation_other_value, String

      def self.choices
        Relation.string_values
      end
      validates_inclusion_of :relation, in: choices

      validates_presence_of :relation_other_value, if: :other_value_needed?

      private

      def relation_value
        Relation.new(relation)
      end

      def other_value
        relation_other_value if other_value_needed?
      end

      def other_value_needed?
        relation.eql?(Relation::OTHER.to_s)
      end

      def attributes_to_reset
        return {} if record.relation.eql?(relation_value.to_s)

        # If the `relation` has changed we need to ensure all the non-parent
        # attributes are reset as well, in case some were previously set.
        Hash[Relationship::PERMISSION_ATTRIBUTES.each_slice(1).to_a]
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record.update(
          {
            relation: relation_value,
            relation_other_value: other_value
          }.merge(
            attributes_to_reset
          )
        )
      end
    end
  end
end
