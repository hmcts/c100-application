module Steps
  module Opening
    class PostcodeForm < BaseForm
      attribute :children_postcode, StrippedString
      validates :children_postcode, presence: true, full_uk_postcode: true

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          children_postcode: children_postcode,
        )
      end
    end
  end
end
