module Steps
  module Children
    class SpecialGuardianshipOrderForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :special_guardianship_order

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        child = c100_application.children.find_by!(id: record_id)
        child.update(
          attributes_map
        )
      end
    end
  end
end
