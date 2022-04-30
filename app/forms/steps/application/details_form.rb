module Steps
  module Application
    class DetailsForm < BaseForm
      attribute :application_details, String

      validates_presence_of :application_details

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          application_details: application_details
        )
      end
    end
  end
end
