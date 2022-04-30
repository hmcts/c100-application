module C100App
  module Permission
    class RelationshipRules
      attr_reader :relationship

      def initialize(relationship)
        @relationship = relationship
      end

      # Permission undecided happens when there is no SGO in force, and the
      # applicant's relation to the child is "other".
      #
      # In these cases we need to go through further questions to decide
      # if permission will be needed or not.
      #
      # Consent order applications or 'OtherChild' skip permission rules.
      #
      def permission_undecided?
        return false if consent_order?
        return false if is_other_child?
        return false if special_guardianship_order?

        other_relationship?
      end

      private

      def child
        @_child ||= relationship.minor
      end

      def is_other_child?
        child.instance_of?(OtherChild)
      end

      def special_guardianship_order?
        child.special_guardianship_order.eql?(
          GenericYesNo::YES.to_s
        )
      end

      def other_relationship?
        relationship.relation.eql?(
          Relation::OTHER.to_s
        )
      end

      def consent_order?
        relationship.c100_application.consent_order?
      end
    end
  end
end
