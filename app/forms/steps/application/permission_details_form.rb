module Steps
  module Application
    class PermissionDetailsForm < BaseForm
      attribute :permission_details, String

      validates_presence_of :permission_details

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          permission_details: permission_details
        )
      end
    end
  end
end
