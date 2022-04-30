module C100App
  module Permission
    class ApplicationRules
      # To improve code readability
      PERMISSION_REQUIRED = true

      ALL_ORDERS = {
        questions: %i[
          parental_responsibility living_order amendment time_order
        ],
        allowed_orders: PetitionOrder.values
      }.freeze

      CAO_ORDERS = {
        questions: %i[
          living_arrangement consent family local_authority
        ],
        allowed_orders: [
          PetitionOrder::CHILD_ARRANGEMENTS_HOME, PetitionOrder::CHILD_ARRANGEMENTS_TIME
        ]
      }.freeze

      CAO_HOME_ORDERS = {
        questions: %i[
          relative
        ],
        allowed_orders: [
          PetitionOrder::CHILD_ARRANGEMENTS_HOME
        ]
      }.freeze

      attr_reader :c100_application

      def initialize(c100_application)
        @c100_application = c100_application
      end

      # From most common to less common, to avoid running unnecessary code/rules.
      #
      #   1. Consent order applications are exempt from permission.
      #
      #   2. If any of the children in the application has a SGO in force,
      #      permission is required, no need to check anything else.
      #
      #   3. Finally, we need to check each applicant-child relationship and the
      #      orders they are applying for to decide if permission will be needed.
      #
      def permission_needed?
        return false if consent_order?
        return true  if children_with_sgo?

        relationships_require_permission?
      end

      # If for some reason permission was required, and details entered, but later
      # something changed in the application that made the permission not required,
      # we wipe/reset these attributes as otherwise showing their values would be
      # confusing on the CYA page and on the PDF.
      #
      def reset_permission_details!
        c100_application.update(
          permission_sought: nil,
          permission_details: nil,
        )
      end

      private

      def consent_order?
        c100_application.consent_order?
      end

      def children_with_sgo?
        c100_application.children.with_special_guardianship_order?
      end

      # Only loop through relationships that entered the non-parents journey,
      # i.e. those having at least the first of those attributes as not `nil`.
      #
      def relationships_require_permission?
        c100_application.relationships.with_permission_data.one? do |relationship|
          next if can_apply_for?(
            ALL_ORDERS, relationship: relationship, child_orders: []
          )

          # Following checks are based on the orders selected for this child
          child_orders = relationship.minor.child_order.orders

          next if can_apply_for?(
            CAO_ORDERS, relationship: relationship, child_orders: child_orders
          )

          next if can_apply_for?(
            CAO_HOME_ORDERS, relationship: relationship, child_orders: child_orders
          )

          # If we reach this point, permission is required no matter what for at
          # least one child, and there is no point looping through the rest
          break PERMISSION_REQUIRED
        end
      end

      # We check if any of the non-parent questions was answered `yes` and if so,
      # we also check that all the orders for this child are allowed to apply.
      #
      def can_apply_for?(config, relationship:, child_orders:)
        questions = config.fetch(:questions)
        allowed_orders = config.fetch(:allowed_orders).map(&:to_s)

        relationship.slice(questions).values.any?(GenericYesNo::YES.to_s) &&
          (child_orders - allowed_orders).empty?
      end
    end
  end
end
