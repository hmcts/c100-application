module Steps
  module Application
    class DeclarationForm < BaseForm
      attribute :declaration_signee, StrippedString
      attribute :declaration_confirmation, StrippedString
      attribute :declaration_signee_capacity, String

      validates_presence_of  :declaration_signee
      validates_inclusion_of :declaration_signee_capacity, in: UserType.string_values
      validates_inclusion_of :declaration_confirmation, in: UserType.string_values

      # This final form object performs a `c100_application` fulfilment validation,
      # essentially a top level sanity check. Refer to `ApplicationFulfilmentValidator`
      validate :application_fulfilment, if: :c100_application

      private

      def application_fulfilment
        c100_application.valid?(:completion) || errors.add(:c100_application)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          declaration_signee: declaration_signee,
          declaration_signee_capacity: declaration_signee_capacity,
        )
      end
    end
  end
end
